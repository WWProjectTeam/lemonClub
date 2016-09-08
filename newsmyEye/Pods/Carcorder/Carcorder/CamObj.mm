//
//  CamObj.m
//
#import <sys/time.h>
#import <CoreVideo/CVPixelBuffer.h>
#import <AVFoundation/AVFoundation.h>
#import "CamObj.h"
//#import "H264iPhone.h"
#import "DelegateCamera.h"
#import "PPCS_API.h"
#import "AVStream_IO_proto.h"
//#import "H264iPhone.h"
#import "OpenALPlayer.h"
#import "VideoPackage.h"
#import "H264Decoder.h"
#import <CoreMedia/CMSampleBuffer.h>
#include <stdlib.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#define  _NALU_SPS_  0
#define  _NALU_PPS_  1
#define  _NALU_I_    2
#define  _NALU_P_    3

#define CHANNEL_DATA	1
#define CHANNEL_IOCTRL	2


#define MAX_SIZE_IOCTRL_BUF   5120    //5K
#define MAX_SIZE_AV_BUF       262144  //256K
#define MAX_SIZE_AUDIO_PCM    3200
#define MAX_SIZE_AUDIO_SAMPLE 640

#define MAX_AUDIO_BUF_NUM     25
#define MIN_AUDIO_BUF_NUM     1
typedef struct MP4V2_CONTEXT{
    
    int m_vWidth,m_vHeight,m_vFrateR,m_vTimeScale;
    MP4FileHandle m_mp4FHandle;
    MP4TrackId m_vTrackId,m_aTrackId;
    double m_vFrameDur;
    
} MP4V2_CONTEXT;
struct MP4V2_CONTEXT * recordCtx = NULL;
int  gAPIVer   =0;
@interface CamObj()
{
    BOOL m_bHasIFrame;
    MP4FileHandle file;
    MP4TrackId video;
    BOOL isRecording;
    NSString *filePath;
}
@end

@implementation CamObj
@synthesize nRowID, mCamState;
@synthesize m_bRunning, m_bVideoPlaying, m_bAudioDecording;
@synthesize mVideoHeight, mVideoWidth;
@synthesize m_fifoVideo, m_fifoAudio;
@synthesize mLockConnecting;
@synthesize nsCamName, nsDID;
@synthesize m_delegateCam;
@synthesize mP2PListener;

#pragma mark -
#pragma mark init and release
- (void) initValue
{
    nRowID    =-1;
    nsCamName =@"";
    nsDID     =@"";

    mConnMode=CONN_MODE_UNKNOWN;
    mCamState=CONN_INFO_UNKNOWN;
    
    m_nTickUpdateInfo=0L;
    m_bVideoPlaying  =NO;
    m_bAudioDecording=NO;
    m_bRunning=NO;
    
    ison =@"off";
    
    mThreadPlayVideo  =nil;
    mThreadDecordAudio=nil;
    mThreadRecvAVData =nil;
//    mLockPlayVideo   =nil;
//    mLockDecordAudio =nil;
//    mLockRecvAVData  =nil;
    
    m_handle    =-1;
    mWaitTime_ms=0L;

    mVideoHeight=0;
    mVideoWidth =0;
    
    m_fifoAudio=av_FifoNew();
    m_fifoVideo=av_FifoNew();
    m_nInitH264Decoder=-1;

    m_bConnecting=0;
    self.mLockConnecting=[[NSLock alloc] init];
    
    m_delegateCam=nil;
    mH264Decoder=nil; // zybo
    isRecording=NO;
}

- (id)init
{
    if((self = [super init])) [self initValue];
    return self;
}

- (void) releaseObj
{
    NSLog(@"p2p release");
//zybo    [nsCamName release];
// zybo   [nsDID release];
    nsCamName=nil;
    nsDID=nil;
    
    if(m_fifoVideo){
        av_FifoRelease(m_fifoVideo);
        m_fifoVideo=NULL;
    }
    if(m_fifoAudio){
        av_FifoRelease(m_fifoAudio);
        m_fifoAudio=NULL;
    }
    
//  zybo  [mLockConnecting release];
    mLockConnecting=nil;
}

+ (void) initAPI
{
//    char Para[]={"ECGBFFBJKAIEGHJAEBHLFGEMHLNBHCNIGEFCBNCIBIJALMLFCFAPCHODHOLCJNKIBIMCLDCNOBMOAKDMJGNMIJBJML"};
//    char Para[] ={"EBGAEOBOKEJPHIJIENGNEAEAHHNNDPJFGLEBBCHNBAMBKMPLCAEHDBKKHFPBMBKAEIJAKCDKKIIFFPDDNCNNMIADIEOFFNDGEJCPDLFEMAOA"};
    char Para[] ={"EBGAEIBIKHJJGFJKEHGEFGEKHNMOHANJGFENBOCNBDJLLELPCJADCLOOHELIJHKEBHMNLNCPODMMAODMJGNPIABCMA"};
    PPCS_Initialize(Para);
    gAPIVer = PPCS_GetAPIVersion();
    NSLog(@"gAPIVer=0x%X", gAPIVer);
}

+ (void) deinitAPI
{
//    NSLog(@"p2p deinit");
//    PPCS_DeInitialize();
}

+ (NSString *) infoCode2Str:(int)infoCode
{
    NSString *result=@"";    
    switch(infoCode) {
        case CONN_INFO_NO_NETWORK:
            result=NSLocalizedString(@"Network is not reachable",nil);
            break;
            
        case CONN_INFO_CONNECTING:
            result=NSLocalizedString(@"Connecting...",nil);
            break;
            
        case CONN_INFO_CONNECT_WRONG_DID:
            result=NSLocalizedString(@"Wrong DID",nil);
            break;
            
        case CONN_INFO_CONNECT_WRONG_PWD:
            result=NSLocalizedString(@"Wrong password",nil);
            break;
            
        case CONN_INFO_CONNECT_FAIL:
            result=NSLocalizedString(@"Failed to connect",nil);
            break;
            
        case CONN_INFO_CONNECTED:
            result=NSLocalizedString(@"Connected",nil);
            break;
            
        case STATUS_INFO_SESSION_CLOSED:
            result=NSLocalizedString(@"Disconnected",nil);
            break;
            
        default:
            break;
    }
    return result;
}

#pragma mark - misc function
+ (unsigned long) getTickCount
{
	struct timeval tv;
	if(gettimeofday(&tv, NULL)!=0) return 0;
	return (tv.tv_sec*1000 +tv.tv_usec/1000);
}

-(void) ResetAudioVar
{
    NSLog(@"p2p reset audio var");
	m_nFirstTickLocal_audio=0L;
	m_nTick2_audio=0L;
	m_nFirstTimestampDevice_audio=0L;
    
	av_FifoEmpty(m_fifoAudio);
}

-(void) ResetVideoVar
{
    NSLog(@"p2p reset video var");
	m_nFirstTickLocal_video=0L;
	m_nTick2_video=0L;
	m_nFirstTimestampDevice_video=0L;

	av_FifoEmpty(m_fifoVideo);
    m_bFirstFrame=TRUE;
}

- (BOOL) mayContinue
{
    if(nsDID==nil || [nsDID length]<=0) return NO;
    else return YES;
}

-(int) readDataFromRemote:(int) handleSession
              withChannel:(unsigned char) Channel
                  withBuf:(char *)DataBuf

             withDataSize: (int *)pDataSize withTimeout:(int)TimeOut_ms
{
//    NSLog(@"p2p read data from remote ");
	INT32 nRet=-1, nTotalRead=0, nRead=0;
	while(nTotalRead < *pDataSize){
		nRead=*pDataSize-nTotalRead;
		if(handleSession>=0)
            nRet=PPCS_Read(handleSession, Channel,DataBuf+nTotalRead, &nRead, TimeOut_ms);
		else
            break;
		nTotalRead+=nRead;
        
		if((nRet != ERROR_PPCS_SUCCESSFUL) && (nRet != ERROR_PPCS_TIME_OUT )) break;
        
        if (nRet == ERROR_PPCS_TIME_OUT) {
            NSLog(@"time out during read !");
            usleep(1000);
        }
        
		if(!m_bRunning) break;
	}
	//NSLog(@" readDataFromRemote(.)=%d, *pDataSize=%d\n", nRet, *pDataSize);
	if(nRet<0) *pDataSize=nTotalRead;
	return nRet;
}

//=={{audio: ADPCM codec==============================================================
INT32 g_nAudioPreSample=0;
INT32 g_nAudioIndex=0;

static int gs_index_adjust[8]= {-1,-1,-1,-1,2,4,6,8};
static int gs_step_table[89] = 
{
	7,8,9,10,11,12,13,14,16,17,19,21,23,25,28,31,34,37,41,45,
	50,55,60,66,73,80,88,97,107,118,130,143,157,173,190,209,230,253,279,307,337,371,
	408,449,494,544,598,658,724,796,876,963,1060,1166,1282,1411,1552,1707,1878,2066,
	2272,2499,2749,3024,3327,3660,4026,4428,4871,5358,5894,6484,7132,7845,8630,9493,
	10442,11487,12635,13899,15289,16818,18500,20350,22385,24623,27086,29794,32767
};

void Encode(unsigned char *pRaw, int nLenRaw, unsigned char *pBufEncoded)
{
    NSLog(@"encode");
	short *pcm = (short *)pRaw;
	int cur_sample;
	int i;
	int delta;
	int sb;
	int code;
	nLenRaw >>= 1;

	for(i = 0; i<nLenRaw; i++)
	{
		cur_sample = pcm[i]; 
		delta = cur_sample - g_nAudioPreSample;
		if (delta < 0){
			delta = -delta;
			sb = 8;
		}else sb = 0;

		code = 4 * delta / gs_step_table[g_nAudioIndex];	
		if (code>7)	code=7;

		delta = (gs_step_table[g_nAudioIndex] * code) / 4 + gs_step_table[g_nAudioIndex] / 8;
		if(sb) delta = -delta;

		g_nAudioPreSample += delta;
		if (g_nAudioPreSample > 32767) g_nAudioPreSample = 32767;
		else if (g_nAudioPreSample < -32768) g_nAudioPreSample = -32768;

		g_nAudioIndex += gs_index_adjust[code];
		if(g_nAudioIndex < 0) g_nAudioIndex = 0;
		else if(g_nAudioIndex > 88) g_nAudioIndex = 88;

		if(i & 0x01) pBufEncoded[i>>1] |= code | sb;
		else pBufEncoded[i>>1] = (code | sb) << 4;
	}
}

void Decode(char *pDataCompressed, int nLenData, char *pDecoded)
{
    NSLog(@"decode");
	int i;
	int code;
	int sb;
	int delta;
	short *pcm = (short *)pDecoded;
	nLenData <<= 1;

	for(i=0; i<nLenData; i++)
	{
		if(i & 0x01) code = pDataCompressed[i>>1] & 0x0f;
		else code = pDataCompressed[i>>1] >> 4;

		if((code & 8) != 0) sb = 1;
		else sb = 0;
		code &= 7;

		delta = (gs_step_table[g_nAudioIndex] * code) / 4 + gs_step_table[g_nAudioIndex] / 8;
		if(sb) delta = -delta;

		g_nAudioPreSample += delta;
		if(g_nAudioPreSample > 32767) g_nAudioPreSample = 32767;
		else if (g_nAudioPreSample < -32768) g_nAudioPreSample = -32768;

		pcm[i] = g_nAudioPreSample;
		g_nAudioIndex+= gs_index_adjust[code];
		if(g_nAudioIndex < 0) g_nAudioIndex = 0;
		if(g_nAudioIndex > 88) g_nAudioIndex= 88;
	}
}
//==}}audio: ADPCM codec==============================================================

#pragma mark - interface of CamObj
- (NSInteger)sendIOCtrl:(int) handleSession withIOType:(int) nIOCtrlType withIOData:(char *)pIOData withIODataSize:(int)nIODataSize
{
    NSLog(@"p2p sendIOCtrl");
    NSInteger nRet=0;
    
    int nLenHead=sizeof(st_AVStreamIOHead)+sizeof(st_AVIOCtrlHead);
	char *packet=new char[nLenHead+nIODataSize];
	st_AVStreamIOHead *pstStreamIOHead=(st_AVStreamIOHead *)packet;
	st_AVIOCtrlHead *pstIOCtrlHead	 =(st_AVIOCtrlHead *)(packet+sizeof(st_AVStreamIOHead));

	pstStreamIOHead->nStreamIOHead=sizeof(st_AVIOCtrlHead)+nIODataSize;
	pstStreamIOHead->uionStreamIOHead.nStreamIOType=SIO_TYPE_IOCTRL;

	pstIOCtrlHead->nIOCtrlType	  =nIOCtrlType;
	pstIOCtrlHead->nIOCtrlDataSize=nIODataSize;

	if(pIOData) memcpy(packet+nLenHead, pIOData, nIODataSize);

	int nSize=nLenHead+nIODataSize;
	nRet=PPCS_Write(handleSession, CHANNEL_IOCTRL, packet, nSize);
	delete []packet;
	NSLog(@"SendIOCtrl(..): PPCS_Write(..)=%d\n", nRet);

    return nRet;
}

- (BOOL) isConnected
{
    return (m_handle>=0 ? YES : NO);
}

- (void) stopAll
{
    NSLog(@"p2p stop all");
    [self closeAudio];
    [self stopVideo];
    [self stopConnect];
}

INT32 myGetDataSizeFrom(st_AVStreamIOHead *pStreamIOHead)
{
	INT32 nDataSize=pStreamIOHead->nStreamIOHead;
	nDataSize &=0x00FFFFFF;
	return nDataSize;
}

- (NSInteger) startConnect:(unsigned long)waitTime_sec
{
    NSLog(@"p2p start connect");
    if(![self mayContinue]) return -1;
    else if(m_bConnecting) return -2;
    else {
        m_bConnecting=1;
//        [mLockConnecting lock];
        mConnMode=CONN_MODE_UNKNOWN;
        
        char *sDID=NULL;
        sDID=(char *)[nsDID cStringUsingEncoding:NSASCIIStringEncoding];
        if (mP2PListener >=0 &&
            [mP2PListener respondsToSelector:@selector(onP2PConnectting)]) {
            [mP2PListener onP2PConnectting];
        }
        for (int i = 0 ; i < 6; i++) {
            m_handle=PPCS_Connect(sDID, 1, 0);
            if (m_handle >= 0)
                break;
            usleep(100000);
        }
        if(m_handle>=0){
            st_PPCS_Session SInfo;
            memset(&SInfo, 0, sizeof(SInfo));
            PPCS_Check(m_handle, &SInfo);
            mConnMode=SInfo.bMode;
            
            //create receiving data thread
            if(mThreadRecvAVData==nil){
                m_bRunning=YES;
//                mLockRecvAVData=[[NSConditionLock alloc] initWithCondition:NOTDONE];
                mThreadRecvAVData=[[NSThread alloc] initWithTarget:self
                                                          selector:@selector(ThreadRecvAVData)
                                                            object:nil];
                [mThreadRecvAVData start];
            }
            if(mP2PListener >=0 &&
               [mP2PListener respondsToSelector:@selector(onP2PConnected)]) {
                [mP2PListener onP2PConnected];
            }
        } else {
            NSLog(@"p2p connect failed, code :%d", m_handle);
            if (mP2PListener >=0 &&
                [mP2PListener respondsToSelector:@selector(onP2PConnectionError)]) {
                [mP2PListener onP2PConnectionError];
            }
        }
//    [mLockConnecting unlock];
        m_bConnecting=0;
    }
    return m_handle;
}

- (void) stopConnect
{
    NSLog(@"p2p stop connect");
    PPCS_Connect_Break();
    
    if(m_handle>=0) {
//        PPCS_Close(m_handle);
        PPCS_ForceClose(m_handle);
        
        //stop receiving data thread
        m_bRunning=NO;
        if(mThreadRecvAVData!=nil){
//            [mLockRecvAVData lockWhenCondition:DONE];
//            [mLockRecvAVData unlock];
            
//    zybo        [mLockRecvAVData release];
//            mLockRecvAVData  =nil;
//       zybo     [mThreadRecvAVData release];
            mThreadRecvAVData=nil;
        }
        
        m_handle=-1;
        if (mP2PListener>=0 && [mP2PListener respondsToSelector:@selector(onP2PDisConnected)]) {
            [mP2PListener onP2PDisConnected];
        }
    }
}

- (NSInteger) openAudio
{
    NSLog(@"p2p open audio");
    NSInteger nRet=-1;
    nRet=[self sendIOCtrl:m_handle
               withIOType:IOCTRL_TYPE_AUDIO_START
               withIOData:NULL
           withIODataSize:0];
    
    if(nRet>=0 && mThreadDecordAudio==nil){
        [self ResetAudioVar];
//        mLockDecordAudio=[[NSConditionLock alloc] initWithCondition:NOTDONE];
        mThreadDecordAudio=[[NSThread alloc] initWithTarget:self
                                                   selector:@selector(ThreadDecordAudio)
                                                     object:nil];
        [mThreadDecordAudio start];
    }
    return nRet;
}

- (void) closeAudio
{
    NSInteger nRet=-1;
    nRet=[self sendIOCtrl:m_handle
               withIOType:IOCTRL_TYPE_AUDIO_STOP
               withIOData:NULL
           withIODataSize:0];
    NSLog(@"closeAudio, nRet=%d", nRet);
    
    m_bAudioDecording=NO;
    if(mThreadDecordAudio!=nil){
//        [mLockDecordAudio lockWhenCondition:DONE];
//        [mLockDecordAudio unlock];
//        
//// zybo       [mLockDecordAudio release];
//        mLockDecordAudio  =nil;
// zybo       [mThreadDecordAudio release];
        mThreadDecordAudio=nil;
    }
}

- (NSInteger) startVideo
{
    NSLog(@"p2p start video");
    NSInteger nRet=-1;
    nRet=[self sendIOCtrl:m_handle
               withIOType:IOCTRL_TYPE_VIDEO_START
               withIOData:NULL
           withIODataSize:0];
    
    mH264Decoder = [[H264Decoder alloc] init];
    if(nRet>=0 && mThreadPlayVideo==nil){
//        mLockPlayVideo=[[NSConditionLock alloc] initWithCondition:NOTDONE];
        mThreadPlayVideo=[[NSThread alloc] initWithTarget:self
                                                 selector:@selector(ThreadPlayVideo)
                                                   object:nil];
        [mThreadPlayVideo start];
    }
    return nRet;
}

- (void) stopVideo
{
    NSLog(@"p2p stop video");
    NSInteger nRet=-1;
    m_bVideoPlaying=NO;
    nRet=[self sendIOCtrl:m_handle
               withIOType:IOCTRL_TYPE_VIDEO_STOP
               withIOData:NULL
           withIODataSize:0];
    NSLog(@"stopVideo, nRet=%d", nRet);
    
    if(nRet>=0 && mThreadPlayVideo!=nil){
//        [mLockPlayVideo lockWhenCondition:DONE];
//        [mLockPlayVideo unlock];
        
//zybo        [mLockPlayVideo release];
//        mLockPlayVideo  =nil;
//zybo        [mThreadPlayVideo release];
        mThreadPlayVideo=nil;
    }
}

-(void)iamgeBack{
}

-(void) myDoVideoData:(CHAR *)pData
{
//    NSLog(@"my do video data");
	st_AVFrameHead stFrameHead;
	int nLenFrameHead=sizeof(stFrameHead);
	memcpy(&stFrameHead, pData, nLenFrameHead);
	long nDiffTimeStamp=0L;
    
    //update online num every 3s
    unsigned long nTick2=[CamObj getTickCount];
    NSUInteger nTimespan=nTick2-m_nTickUpdateInfo;
    if(nTimespan==0) nTimespan=1000;
    if(nTimespan>=3000 || m_bFirstFrame){
        m_nTickUpdateInfo=nTick2;
        NSUInteger totalFrame=mTotalFrame;
        mTotalFrame=0;
        nTimespan=nTimespan/1000;
        //NSLog(@"myDoVideoData, stFrameHead.status=%d, totalFrame=%d\n", stFrameHead.status, totalFrame);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.m_delegateCam && [self.m_delegateCam respondsToSelector:@selector(refreshSessionInfo:OnlineNm:TotalFrame:Time:)])
                [self.m_delegateCam refreshSessionInfo:mConnMode OnlineNm:stFrameHead.nOnlineNum TotalFrame:totalFrame Time:nTimespan];
        });
    }
    
    if (stFrameHead.nCodecID != CODECID_V_H264) {
        NSLog(@"NOT H264 Frame , code : = %d\n", stFrameHead.nCodecID);
        return;
    }
    
    int typeIndex = 4 + nLenFrameHead;
    int type = pData[typeIndex] & 0x1f;
    
    //    uint32_t nalSize = (uint32_t)(vp.size - 4);
    //    uint8_t *pNalSize = (uint8_t*)(&nalSize);
    //    vp.buffer[0] = *(pNalSize + 3);
    //    vp.buffer[1] = *(pNalSize + 2);
    //    vp.buffer[2] = *(pNalSize + 1);
    //    vp.buffer[3] = *(pNalSize);
    
    if(m_bFirstFrame && stFrameHead.flag!=VFRAME_FLAG_I) return;
    m_bFirstFrame=FALSE;
    //
    VideoPackage * vp = [VideoPackage alloc];
    vp.size = stFrameHead.nDataSize;
    vp.buffer = (uint8_t *)(pData + nLenFrameHead);
    
    if(isRecording)
    {
        mp4VEncode(vp.buffer, vp.size);
    }
    
    uint32_t nalSize = (uint32_t)(vp.size - 4);
    uint8_t *pNalSize = (uint8_t*)(&nalSize);
    vp.buffer[0] = *(pNalSize + 3);
    vp.buffer[1] = *(pNalSize + 2);
    vp.buffer[2] = *(pNalSize + 1);
    vp.buffer[3] = *(pNalSize);
    CVPixelBufferRef pixelBuffer = NULL;
    BOOL decodeError = NO;

    switch (type) {
        case 7:
            NSLog(@"get sps frame");
            [mH264Decoder setSPS:vp];
            break;
        case 8:
            NSLog(@"get pps frame");
            [mH264Decoder setPPS:vp];
            break;
        case 5:
            m_bHasIFrame = true;
            [mH264Decoder initDecoder];
            pixelBuffer = [mH264Decoder decode:vp];
            if (pixelBuffer == NULL)
                decodeError = YES;
            break;
        case 1:
            if (m_bHasIFrame) {
                pixelBuffer =   [mH264Decoder decode:vp];
                if (pixelBuffer == NULL)
                    decodeError = YES;
            }
            break;
        default:
            break;
    }
    
    if (decodeError && mP2PListener) {
        [mP2PListener onP2PConnectionError];
        return;
    }
    
    mVideoHeight =CVPixelBufferGetHeight(pixelBuffer);
    mVideoWidth= CVPixelBufferGetWidth(pixelBuffer);
    if (pixelBuffer >0 &&
        [mP2PListener respondsToSelector:@selector(onPixelBufferAvaiable:)] == true) {
//        NSLog(@"decoded frame , type : = %d \n", type);
        dispatch_sync(dispatch_get_main_queue(), ^{
             [mP2PListener onPixelBufferAvaiable:pixelBuffer];//
            CVPixelBufferRelease(pixelBuffer);
                });
            }
}
int mp4VEncode(uint8_t * _naluData ,int _naluSize){
    
    int index = -1;
    
    if(_naluData[0]==0 && _naluData[1]==0 && _naluData[2]==0 && _naluData[3]==1 && (_naluData[4] & 0x1f) == 7){
        index = _NALU_SPS_;
    }
    
    if(index!=_NALU_SPS_ && recordCtx->m_vTrackId == MP4_INVALID_TRACK_ID){
        return index;
    }
    if(_naluData[0]==0 && _naluData[1]==0 && _naluData[2]==0 && _naluData[3]==1 &&(_naluData[4] & 0x1f) == 8){
        index = _NALU_PPS_;
    }
    if(_naluData[0]==0 && _naluData[1]==0 && _naluData[2]==0 && _naluData[3]==1 && (_naluData[4] & 0x1f) == 5){
        index = _NALU_I_;
    }
    if(_naluData[0]==0 && _naluData[1]==0 && _naluData[2]==0 && _naluData[3]==1 && (_naluData[4] & 0x1f) == 1){
        index = _NALU_P_;
    }
    //
    switch(index){
        case _NALU_SPS_:
            if(recordCtx->m_vTrackId == MP4_INVALID_TRACK_ID){
                recordCtx->m_vTrackId = MP4AddH264VideoTrack
                (recordCtx->m_mp4FHandle,
                 recordCtx->m_vTimeScale,
                 recordCtx->m_vTimeScale / recordCtx->m_vFrateR,
                 recordCtx->m_vWidth,     // width
                 recordCtx->m_vHeight,    // height
                 _naluData[5], // sps[1] AVCProfileIndication
                 _naluData[6], // sps[2] profile_compat
                 _naluData[7], // sps[3] AVCLevelIndication
                 3);           // 4 bytes length before each NAL unit
                if (recordCtx->m_vTrackId == MP4_INVALID_TRACK_ID)  {
                    return -1;
                }
                MP4SetVideoProfileLevel(recordCtx->m_mp4FHandle, 0x7F); //  Simple Profile @ Level 3
            }
            MP4AddH264SequenceParameterSet(recordCtx->m_mp4FHandle,recordCtx->m_vTrackId,_naluData+4,_naluSize-4);
            //
            break;
        case _NALU_PPS_:
            MP4AddH264PictureParameterSet(recordCtx->m_mp4FHandle,recordCtx->m_vTrackId,_naluData+4,_naluSize-4);
            break;
        case _NALU_I_:
        case _NALU_P_:
        {
            _naluData[0] = (_naluSize-4) >>24;
            _naluData[1] = (_naluSize-4) >>16;
            _naluData[2] = (_naluSize-4) >>8;
            _naluData[3] = (_naluSize-4) &0xff;
            
            //            if(!MP4WriteSample(recordCtx->m_mp4FHandle, recordCtx->m_vTrackId, _naluData, _naluSize, recordCtx->m_vFrameDur/44100*90000, 0, 1)){
            //                return -1;
            //            }
            //            recordCtx->m_vFrameDur = 0;
            if(!MP4WriteSample(recordCtx->m_mp4FHandle, recordCtx->m_vTrackId, _naluData, _naluSize, MP4_INVALID_DURATION, 0, 1)){
                return -1;
            }
            break;
        }
    }
    return 0;
}
//-(void)image:(UIImage*)imagedidFinishSavingWithError:(NSError*)errorcontextInfo:(void*)contextInfo
//{
//    if(!error){
//        NSLog(@"savesuccess");
//    }else{
//        NSLog(@"savefailed");
//    }
//}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message…
        NSLog(@"11111111111111111111111111111111");
        
    }
    else  // No errors
    {
        // Show message image successfully saved
    }
}

//video: decord and display it
- (void)ThreadPlayVideo
{
    NSLog(@"p2p thread play video");
    block_t *pBlock=NULL;
    NSLog(@"    ThreadPlayVideo, nNumFiFo=%d", av_FifoCount(m_fifoVideo));
    
    m_nTickUpdateInfo =0L;
    mTotalFrame=0;

//    [mLockPlayVideo lock];
//zybo    m_nInitH264Decoder=InitCodec(1);
    m_pBufBmp24=(unsigned char *)malloc(MAXSIZE_IMG_BUFFER);
    m_bVideoPlaying=YES;
    while(m_bVideoPlaying){
        pBlock=av_FifoGetAndRemove(m_fifoVideo);
        if(pBlock==NULL){
            usleep(8000);
            continue;
        }

        [self myDoVideoData:pBlock->p_buffer];
        block_Release(pBlock);
        pBlock=NULL;
    }
    free(m_pBufBmp24);
//zybo    UninitCodec();
//    [mLockPlayVideo unlockWithCondition:DONE];
    
    NSLog(@"=== ThreadPlayVideo exit ===");
}


//audio: decord and play it
- (void)ThreadDecordAudio
{
    NSLog(@"thread decode audio");
    NSLog(@"  --- ThreadDecordAudio, going...\n");
    int nAudioFIFONum=0, nAUDIO_BUF_NUM=MAX_AUDIO_BUF_NUM;
//    [mLockDecordAudio lock];
    block_t *pBlock=NULL;
    st_AVFrameHead stFrameHead;
    int  nLenFrameHead=sizeof(st_AVFrameHead), nFrameSize=0;
    char *pFrame=NULL;
    char *outPCM=(char *)malloc(MAX_SIZE_AUDIO_PCM);
    int  nTimeSleep=25000, nSizePCM=0;
    char bufTmp[640];
    
    OpenALPlayer *player = nil;
    player = [[OpenALPlayer alloc] init];
    int format=AL_FORMAT_MONO16, nSamplingRate=8000;
    [player initOpenAL:format :nSamplingRate];

    g_nAudioIndex=0;
    g_nAudioPreSample=0;
    m_bAudioDecording=YES;
    while(m_bAudioDecording){
        nAudioFIFONum=av_FifoCount(m_fifoAudio);
        if(nAudioFIFONum<nAUDIO_BUF_NUM){
            if(nAUDIO_BUF_NUM==MIN_AUDIO_BUF_NUM) nAUDIO_BUF_NUM=MAX_AUDIO_BUF_NUM;
            usleep(4000);
            continue;
        }else nAUDIO_BUF_NUM=MIN_AUDIO_BUF_NUM;
        
        pBlock=av_FifoGetAndRemove(m_fifoAudio);
        if(pBlock==NULL) continue;
        
        memcpy(&stFrameHead, pBlock->p_buffer, nLenFrameHead);        
        pFrame=(pBlock->p_buffer+nLenFrameHead);
        nFrameSize=stFrameHead.nDataSize;
        if(stFrameHead.nCodecID==CODECID_A_ADPCM){
            nSizePCM=0;
            for(int i=0; i<nFrameSize/160; i++){
                Decode((char *)pFrame+i*160, 160, bufTmp);
                memcpy(outPCM+nSizePCM, bufTmp, 640);
                nSizePCM+=640;
            }

            [player openAudioFromQueue:[NSData dataWithBytes:outPCM length:nSizePCM]];
            usleep(nTimeSleep);
            //NSLog(@"adpcm, nTimeSleep=%d nFrameSize=%d, nSizePCM=%d", nTimeSleep, nFrameSize, nSizePCM);
        }
        block_Release(pBlock);
        pBlock=NULL;
    }
    
    if(outPCM) {
        free(outPCM);
        outPCM=NULL;
    }
    if(player != nil) {
        [player stopSound];
        [player cleanUpOpenAL];
//zybo        [player release];
        player = nil;
    }
//[mLockDecordAudio unlockWithCondition:DONE];
    NSLog(@"=== ThreadDecordAudio exit ===");
}


- (void)ThreadRecvAVData
{
    NSLog(@"thread recv av data");
    NSLog(@"    ThreadRecvAVData going...");
    
	CHAR  *pAVData=(CHAR *)malloc(MAX_SIZE_AV_BUF);
	INT32 nRecvSize=4, nRet=0;
	CHAR  nCurStreamIOType=0;
	st_AVStreamIOHead *pStreamIOHead=NULL;
    block_t *pBlock=NULL;
    
    m_bRunning=YES;
    while(m_bRunning){
		nRecvSize=sizeof(st_AVStreamIOHead);
		nRet=[self readDataFromRemote:m_handle withChannel:CHANNEL_DATA withBuf:pAVData withDataSize:&nRecvSize withTimeout:10000];
		if(nRet == ERROR_PPCS_SESSION_CLOSED_TIMEOUT){
			NSLog(@"ThreadRecvAVData: Session close TimeOUT!!\n");
			break;
		}else if(nRet == ERROR_PPCS_SESSION_CLOSED_REMOTE){
			NSLog(@"ThreadRecvAVData: Session Remote Close, 1!!\n");
			break;
            
		}else if(nRet==ERROR_PPCS_SESSION_CLOSED_CALLED){
			NSLog(@"ThreadRecvAVData: myself called PPCS_Close!!\n");
			break;
            
		}//else NSLog(@"ThreadRecvAVData: errorCode=%d\n", nRet);
        
//        NSLog(@"thread recv data : result = %d, recv size = %d\n", nRet, nRecvSize);
		if(nRecvSize>0){
			pStreamIOHead=(st_AVStreamIOHead *)pAVData;
			nCurStreamIOType=pStreamIOHead->uionStreamIOHead.nStreamIOType;
            
			nRecvSize =  myGetDataSizeFrom(pStreamIOHead);
//            NSLog(@"recv size : %d", nRecvSize);
			nRet = [self readDataFromRemote:m_handle
                              withChannel:CHANNEL_DATA
                                  withBuf:pAVData
                             withDataSize:&nRecvSize
                              withTimeout:10000];
			if(nRet == ERROR_PPCS_SESSION_CLOSED_TIMEOUT){
				NSLog(@"ThreadRecvAVData: Session closed TimeOUT!!\n");
				break;
                
			}else if(nRet == ERROR_PPCS_SESSION_CLOSED_REMOTE){
				NSLog(@"ThreadRecvAVData: Session Remote Close!! , 2\n");
				break;
                
			}else if(nRet==ERROR_PPCS_SESSION_CLOSED_CALLED){
				NSLog(@"ThreadRecvAVData: myself called PPCS_Close!!\n");
				break;
			}
            
			if(nRecvSize>0){
                if(nRecvSize>=MAX_SIZE_AV_BUF) {
                    NSLog(@"====nRecvSize>256K, nCurStreamIOType=%d\n", nCurStreamIOType);
                    break;
                }
                else{
                    //NSLog(@"ThreadRecvAVData: nRecvSize=%d, nCurStreamIOType=%d\n", nRecvSize, nCurStreamIOType);
                    
                    if(nCurStreamIOType==SIO_TYPE_AUDIO){
                        pBlock=(block_t *)malloc(sizeof(block_t));
						block_Alloc(pBlock, pAVData, nRecvSize+sizeof(st_AVStreamIOHead));
						av_FifoPut(m_fifoAudio, pBlock);


                        
                    //音频数据
                    }else if(nCurStreamIOType==SIO_TYPE_VIDEO){
                        pBlock=(block_t *)malloc(sizeof(block_t));
						block_Alloc(pBlock, pAVData, nRecvSize+sizeof(st_AVStreamIOHead));
						av_FifoPut(m_fifoVideo, pBlock);
//                        NSLog(@"frame count is %d",nRecvSize);
//                        for (int i = 0 ; i < nRecvSize ; i++) {
//                            printf("%d", pAVData[i]);
//                        }
//                        printf("\n");
                      
                        
//                        
//                        NSData *adata = [[NSData alloc] initWithBytes:pAVData length:nRecvSize+sizeof(st_AVStreamIOHead)];
////
//                        NSData *h264Data = adata;
//                        NSFileManager *fileManager=[NSFileManager defaultManager];
//                        NSString *filePath2 = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/233.h264"];
//                        NSLog(@"%@",filePath2);
//                        if(![fileManager fileExistsAtPath:filePath2])
//                        {
//                            [fileManager createFileAtPath:filePath2 contents:nil attributes:nil];
//                        }
//                        NSFileHandle *fileHandle=[NSFileHandle fileHandleForUpdatingAtPath:filePath2];
//                        
//                        [fileHandle seekToEndOfFile];
//                        [fileHandle writeData:h264Data];
                        //[adata  writeToFile:filePath2  atomically:YES];
 
                    //视频数据
                    }
                }
			}
		}//if(nRecvSize>0)-end
    }
    
    // connection error
    if (m_bRunning && mP2PListener >=0 &&
        [mP2PListener respondsToSelector:@selector(onP2PConnectionError)]) {
        [mP2PListener onP2PConnectionError];
    }
//    [mLockRecvAVData unlockWithCondition:DONE];
    
    NSLog(@"=== ThreadRecvAVData exit ===");
}

-(BOOL)startRecordVideo;
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
        filePath = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/temp.mp4"];
                            NSLog(@"%@",filePath);
                            if(![fileManager fileExistsAtPath:filePath])
                            {
                                
                        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
                            }
    initMp4Encoder([filePath cStringUsingEncoding:NSASCIIStringEncoding], (int)mVideoWidth, (int)mVideoHeight);
    
    if (mH264Decoder.getPPS == nil) {
        return NO;
    }
    
    int spsSize = mH264Decoder.getSPSSize+4;
    uint8_t * sps = (uint8_t *)malloc(spsSize);
    sps[0] = 0;
    sps[1] = 0;
    sps[2] = 0;
    sps[3] = 1;
    memcpy(sps + 4, mH264Decoder.getSPS, mH264Decoder.getSPSSize);
     mp4VEncode(sps, spsSize);
    
    int ppsSize = mH264Decoder.getPPSSize+4;
    uint8_t * pps = (uint8_t *)malloc(ppsSize);
    pps[0] = 0;
    pps[1] = 0;
    pps[2] = 0;
    pps[3] = 1;
    memcpy(pps + 4, mH264Decoder.getPPS, ppsSize);
    mp4VEncode(pps, ppsSize);
    isRecording=YES;
    
    return YES;
}
-(void)stopRecordVideo
{
    if(isRecording)
    {
       isRecording=NO;
        closeMp4Encoder(); 
    }
}


int initMp4Encoder(const char * filename,int width,int height){
    
    int ret = -1;
    recordCtx = (MP4V2_CONTEXT*)malloc(sizeof(struct MP4V2_CONTEXT));
    if (!recordCtx) {
        printf("error : malloc context \n");
        return ret;
    }
    
    recordCtx->m_vWidth = width;
    recordCtx->m_vHeight = height;
    recordCtx->m_vFrateR = 13;
    recordCtx->m_vTimeScale = 90000;
    recordCtx->m_vFrameDur = 300;
    //recordCtx->m_vFrameDur = 10;
    
    
    recordCtx->m_vTrackId = 0;
    recordCtx->m_aTrackId = 0;
    
    recordCtx->m_mp4FHandle = MP4Create(filename,0);
    if (recordCtx->m_mp4FHandle == MP4_INVALID_FILE_HANDLE) {
        printf("error : MP4Create  \n");
        return ret;
    }
    MP4SetTimeScale(recordCtx->m_mp4FHandle, recordCtx->m_vTimeScale);
    //------------------------------------------------------------------------------------- audio track
    //    recordCtx->m_aTrackId = MP4AddAudioTrack(recordCtx->m_mp4FHandle, 44100, 1024, MP4_MPEG4_AUDIO_TYPE);
    //    if (recordCtx->m_aTrackId == MP4_INVALID_TRACK_ID){
    //        printf("error : MP4AddAudioTrack  \n");
    //        return ret;
    //    }
    //
    //    MP4SetAudioProfileLevel(recordCtx->m_mp4FHandle, 0x2);
    //    uint8_t aacConfig[2] = {18,16};
    //    MP4SetTrackESConfiguration(recordCtx->m_mp4FHandle,recordCtx->m_aTrackId,aacConfig,2);
    //    printf("ok  : initMp4Encoder file=%s  \n",filename);
    
    return 0;
}

int mp4AEncode(uint8_t * data ,int len){
    if(recordCtx->m_vTrackId == MP4_INVALID_TRACK_ID){
        return -1;
    }
    MP4WriteSample(recordCtx->m_mp4FHandle, recordCtx->m_aTrackId, data, len , MP4_INVALID_DURATION, 0, 1);
    recordCtx->m_vFrameDur += 1024;
    return 0;
}

void closeMp4Encoder(){
    if(recordCtx){
        if (recordCtx->m_mp4FHandle != MP4_INVALID_FILE_HANDLE) {
            MP4Close(recordCtx->m_mp4FHandle,0);
            recordCtx->m_mp4FHandle = NULL;
        }
        
        free(recordCtx);
        recordCtx = NULL;
    }
    
    printf("ok  : closeMp4Encoder  \n");
    
}


@end


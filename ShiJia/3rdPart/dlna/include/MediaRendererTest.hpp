/*****************************************************************
|
|   Platinum - Test UPnP A/V MediaRenderer
|
| Copyright (c) 2004-2010, Plutinosoft, LLC.
| All rights reserved.
| http://www.plutinosoft.com
|
| This program is free software; you can redistribute it and/or
| modify it under the terms of the GNU General Public License
| as published by the Free Software Foundation; either version 2
| of the License, or (at your option) any later version.
|
| OEMs, ISVs, VARs and other distributors that combine and 
| distribute commercially licensed software with Platinum software
| and do not wish to distribute the source code for the commercially
| licensed software under version 2, or (at your option) any later
| version, of the GNU General Public License (the "GPL") must enter
| into a commercial license agreement with Plutinosoft, LLC.
| licensing@plutinosoft.com
| 
| This program is distributed in the hope that it will be useful,
| but WITHOUT ANY WARRANTY; without even the implied warranty of
| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
| GNU General Public License for more details.
|
| You should have received a copy of the GNU General Public License
| along with this program; see the file LICENSE.txt. If not, write to
| the Free Software Foundation, Inc., 
| 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
| http://www.gnu.org/licenses/gpl-2.0.html
|
 ****************************************************************/
#ifndef MEDIA_RENDERER_TEST
#define MEDIA_RENDERER_TEST
/*----------------------------------------------------------------------
|   includes
+---------------------------------------------------------------------*/
#include "PltUPnP.h"
#include "PltMediaRenderer.h"

#include <stdlib.h>

/*----------------------------------------------------------------------
|   globals
+---------------------------------------------------------------------*/
struct Options {
    const char* friendly_name;
} Options;

/*----------------------------------------------------------------------
|   PrintUsageAndExit
+---------------------------------------------------------------------*/
static void
PrintUsageAndExit(char** args)
{
    fprintf(stderr, "usage: %s [-f <friendly_name>]\n", args[0]);
    fprintf(stderr, "-f : optional upnp server friendly name\n");
    fprintf(stderr, "<path> : local path to serve\n");
    exit(1);
}

/*----------------------------------------------------------------------
|   ParseCommandLine
+---------------------------------------------------------------------*/
static void
ParseCommandLine(char** args)
{
    const char* arg;
    char**      tmp = args+1;

    /* default values */
    Options.friendly_name = NULL;

    while ((arg = *tmp++)) {
        if (!strcmp(arg, "-f")) {
            Options.friendly_name = *tmp++;
        } else {
            fprintf(stderr, "ERROR: too many arguments\n");
            PrintUsageAndExit(args);
        }
    }
}
#if 0
static int test_main(int /* argc */, char** argv)
{   
    PLT_UPnP upnp;

    /* parse command line */
    ParseCommandLine(argv);

    PLT_DeviceHostReference device(
        new PLT_MediaRenderer(Options.friendly_name?Options.friendly_name:"Simple Platinum Media Renderer",
                              false,
                              "e6572b54-f3c7-2d91-2fb5-b757f2537e21"));
    upnp.AddDevice(device);
    bool added = true;

    upnp.Start();

    char buf[256];
    while (gets(buf)) {
        if (*buf == 'q')
            break;

        if (*buf == 's') {
            if (added) {
                upnp.RemoveDevice(device);
            } else {
                upnp.AddDevice(device);
            }
            added = !added;
        }
    }

    upnp.Stop();
    return 0;
}
#endif

#include "PltUPnP.h"
#include "PltCtrlPoint.h"
#include "PltMediaItem.h"
#include "PltMediaController.h"
#include <boost/signals2.hpp>

typedef boost::signals2::signal<void ()> signal_type;
extern NPT_Lock<signal_type> g_Signal;

PLT_CtrlPointReference ctrlPoint(new PLT_CtrlPoint("ssdp:all"));
PLT_UPnP* mUPnP = new PLT_UPnP();
NPT_Lock<NPT_Map<NPT_String, PLT_DeviceDataReference> > m_MediaRenderers;

NPT_String g_current_Uuid;
NPT_String g_Play_Url;


static void SetAVTransportURI(PLT_DeviceDataReference& device);

class PlatinumMediaControllerDelegate: public PLT_MediaControllerDelegate
{
public:
    PlatinumMediaControllerDelegate()
    {
    }
    
    virtual ~PlatinumMediaControllerDelegate()
    {
        
    }
    
    virtual bool OnMRAdded(PLT_DeviceDataReference& device)
    {
        NPT_String uuid = device->GetUUID();
        printf("\nOnMRAdded %s, ip %s\n", uuid.GetChars(), device->GetURLBase().ToString().GetChars());

        if (g_current_Uuid.IsEmpty()) {
            g_current_Uuid = uuid;
        }
       
        PLT_Service* service;
        if (NPT_SUCCEEDED(device->FindServiceByType("urn:schemas-upnp-org:service:AVTransport:*", service))) {
            NPT_AutoLock lock(m_MediaRenderers);
            m_MediaRenderers.Put(uuid, device);
        }
        NPT_AutoLock lock(g_Signal);
        g_Signal();
#if 0
        [mPlatinumInterface onDeviceAdded:(char*)(uuid.GetChars()) FriendlyName:(char*)(device->GetFriendlyName().GetChars())];
#endif
        return true;
    }
    
    virtual void OnMRRemoved(PLT_DeviceDataReference&  device)
    {
        NPT_String uuid = device->GetUUID();
        printf("\n OnMRRemoved %s\n", uuid.GetChars());

        {
            NPT_AutoLock lock(m_MediaRenderers);
            m_MediaRenderers.Erase(uuid);
        }
        
        NPT_AutoLock lock(g_Signal);
        g_Signal();
#if 0
        [mPlatinumInterface onDeviceRemoved:(char*)(device->GetUUID().GetChars())];
#endif
    }
    
    virtual void OnMRStateVariablesChanged(PLT_Service*                   service,
                                           NPT_List<PLT_StateVariable*>*  vars)
    {
        
        NPT_String name = service->GetDevice()->GetFriendlyName();
        NPT_List<PLT_StateVariable*>::Iterator var = vars->GetFirstItem();
        while (var) {
            printf("\n OnMRStateVariablesChanged Received state var \"%s:%s:%s\" changes: \"%s\"\n",
                   (const char*)name,
                   (const char*)service->GetServiceID(),
                   (const char*)(*var)->GetName(),
                   (const char*)(*var)->GetValue());
            ++var;
        }
    }
    
    // AVTransport
    virtual void OnGetCurrentTransportActionsResult(
                                                    NPT_Result                /*res*/,
                                                    PLT_DeviceDataReference&  /*device*/,
                                                    PLT_StringList*           /*actions*/,
                                                    void*                     /*userdata*/)
    {
        
    }
    
    virtual void OnGetDeviceCapabilitiesResult(
                                               NPT_Result               /*res*/,
                                               PLT_DeviceDataReference& /*device*/,
                                               PLT_DeviceCapabilities*  /*capabilities*/,
                                               void*                    /*userdata*/)
    {
        
    }
    
    virtual void OnGetMediaInfoResult(
                                      NPT_Result               res,
                                      PLT_DeviceDataReference& /*device*/,
                                      PLT_MediaInfo*           info,
                                      void*                    /*userdata*/)
    {
        if (res == 0)
            printf("\nOnGetMediaInfoResult result :%d, curUrl:%s\n", res, info->cur_uri.GetChars());
        else
            printf("\nOnGetMediaInfoResult result :%d\n", res);
    }
    
    virtual void OnGetPositionInfoResult(
                                         NPT_Result               /*res*/,
                                         PLT_DeviceDataReference& /*device*/,
                                         PLT_PositionInfo*        /*info*/,
                                         void*                    /*userdata*/)
    {
#if 0
        if (NPT_FAILED(res)) {
            [mPlatinumInterface OnGetPositionInfoResult:0];
        }
        else {
            [mPlatinumInterface OnGetPositionInfoResult:info->rel_time.ToSeconds()];
        }
#endif
    }
    
    virtual void OnGetTransportInfoResult(
                                          NPT_Result               res,
                                          PLT_DeviceDataReference& device,
                                          PLT_TransportInfo*       /*info*/,
                                          void*                    /*userdata*/)
    {
        printf("\nOnGetTransportInfoResult result :%d\n", res);
    }
    
    virtual void OnGetTransportSettingsResult(
                                              NPT_Result               /*res*/,
                                              PLT_DeviceDataReference& /*device*/,
                                              PLT_TransportSettings*   /*settings*/,
                                              void*                    /*userdata*/)
    {
    }
    
    virtual void OnNextResult(
                              NPT_Result               /*res*/,
                              PLT_DeviceDataReference& /*device*/,
                              void*                    /*userdata*/)
    {
        
    }
    
    virtual void OnPauseResult(
                               NPT_Result               res,
                               PLT_DeviceDataReference& /*device*/,
                               void*                    /*userdata*/)
    {
        printf("\n OnPauseResult result: %d\n", res);
    }
    
    virtual void OnPlayResult(
                              NPT_Result               res,
                              PLT_DeviceDataReference& /*device*/,
                              void*                    /*userdata*/)
    {
        printf("\nOnPlayResult result :%d\n", res);
        
    }
    
    virtual void OnPreviousResult(
                                  NPT_Result               /*res*/,
                                  PLT_DeviceDataReference& /*device*/,
                                  void*                    /*userdata*/)
    {
        
    }
    
    virtual void OnSeekResult(
                              NPT_Result               /*res*/,
                              PLT_DeviceDataReference& /*device*/,
                              void*                    /*userdata*/)
    {
       // [mPlatinumInterface OnSeekResult:res];
    }
    
    virtual void OnSetAVTransportURIResult(
                                           NPT_Result               res,
                                           PLT_DeviceDataReference& device,
                                           void*                    userdata)
    {
        printf("\n####################device: %s SetAVTransportURIResult Did, result:%d\n", (device)->GetFriendlyName().GetChars(), res);
        PLT_MediaController* mediaController = (PLT_MediaController*)userdata;
        
        if (mediaController) {
            NPT_String speed("1");
            int result = mediaController->Play(device, 0, speed, NULL);
            if (result < 0) {
                printf("\nPlay failed.\n");
            } else {
                printf("\n####################device: %s Play Did\n", (*device).GetFriendlyName().GetChars());
            }
        }
    }
    
    virtual void OnSetPlayModeResult(
                                     NPT_Result               /*res*/,
                                     PLT_DeviceDataReference& /*device*/,
                                     void*                    /*userdata*/)
    {
        
    }
    
    virtual void OnStopResult(
                              NPT_Result               /*res*/,
                              PLT_DeviceDataReference& /*device*/,
                              void*                    /*userdata*/)
    {
        //[mPlatinumInterface OnStopResult:res];
    }
    
    // ConnectionManager
    virtual void OnGetCurrentConnectionIDsResult(
                                                 NPT_Result               /*res*/,
                                                 PLT_DeviceDataReference& /*device*/,
                                                 PLT_StringList*          /*ids*/,
                                                 void*                    /*userdata*/)
    {
        
    }
    
    virtual void OnGetCurrentConnectionInfoResult(
                                                  NPT_Result               /*res*/,
                                                  PLT_DeviceDataReference& /*device*/,
                                                  PLT_ConnectionInfo*      /*info*/,
                                                  void*                    /*userdata*/)
    {
        
    }
    
    virtual void OnGetProtocolInfoResult(
                                         NPT_Result               /*res*/,
                                         PLT_DeviceDataReference& /*device*/,
                                         PLT_StringList*          /*sources*/,
                                         PLT_StringList*          /*sinks*/,
                                         void*                    /*userdata*/)
    {
        
    }
    
    // RenderingControl
    virtual void OnSetMuteResult(
                                 NPT_Result               /*res*/,
                                 PLT_DeviceDataReference& /*device*/,
                                 void*                    /*userdata*/)
    {
        //[mPlatinumInterface OnSetMuteResult:res];
    }
    
    virtual void OnGetMuteResult(
                                 NPT_Result               /*res*/,
                                 PLT_DeviceDataReference& /*device*/,
                                 const char*              /*channel*/,
                                 bool                     /*mute*/,
                                 void*                    /*userdata*/)
    {
#if 0
        if (NPT_FAILED(res)) {
            [mPlatinumInterface OnGetMuteResult:2];
        }
        else {
            [mPlatinumInterface OnGetMuteResult:mute?1:0];
        }
#endif
    }
    
    virtual void OnSetVolumeResult(
                                   NPT_Result               /*res*/,
                                   PLT_DeviceDataReference& /*device*/,
                                   void*                    /*userdata*/)
    {
        //[mPlatinumInterface OnSetVolumeResult:res];
    }
    
    virtual void OnGetVolumeResult(
                                   NPT_Result               /*res*/,
                                   PLT_DeviceDataReference& /*device*/,
                                   const char*              /*channel*/,
                                   NPT_UInt32				/*volume*/,
                                   void*                    /*userdata*/)
    {
        //[mPlatinumInterface OnGetVolumeResult:res Volume:volume];
    }
    
    
};

PlatinumMediaControllerDelegate* mDelegate = new PlatinumMediaControllerDelegate;
PLT_MediaController* mMediaController = new PLT_MediaController(ctrlPoint,mDelegate);

static void SetAVTransportURI(NPT_String& uuid, NPT_String& url)
{
    
    if (mDelegate) {
        NPT_String uuidStr(uuid);
        PLT_DeviceDataReference* device;
        m_MediaRenderers.Get(uuidStr, device);
        if (device && !device->IsNull()) {
            mMediaController->SetAVTransportURI(*device, 0, url.GetChars(), "metadata", mMediaController);
        }
    }
}

static void startUpnp()
{
    mUPnP->AddCtrlPoint(ctrlPoint);
    mUPnP->Start();
}

static void stopUpnp()
{
    if (mUPnP->IsRunning()) {
        mUPnP->RemoveCtrlPoint(ctrlPoint);
        mUPnP->Stop();
    }
}

static void searchDMR(unsigned int cardinal, double interval)
{
    ctrlPoint->Search(NPT_HttpUrl("239.255.255.250", 1900, "*"),
                      "ssdp:all", cardinal, NPT_TimeInterval(interval));
}

static bool GetTransportInfo(char* uuid)
{
    bool result = false;
    if (mDelegate) {
        NPT_String uuidStr(uuid);
        PLT_DeviceDataReference* device;
        m_MediaRenderers.Get(uuidStr, device);
        if (device && !device->IsNull()) {
            int methodResult = mMediaController->GetTransportInfo(*device, 0, NULL);
            if (methodResult == 0) {
                result = true;
            }
        }
        
    }
    return result;
}

static void GetDMRPlaybackTime()
{
    
    if (mDelegate) {
        NPT_String uuidStr(g_current_Uuid);
        PLT_DeviceDataReference* device;
        m_MediaRenderers.Get(uuidStr, device);
        if (device && !device->IsNull()) {
            mMediaController->GetPositionInfo(*device, 0, NULL);
        }
    }
}

static void SetMute(bool muted)
{
    if (mDelegate) {
        NPT_String uuidStr(g_current_Uuid);
        PLT_DeviceDataReference* device;
        m_MediaRenderers.Get(uuidStr, device);
        if (device && !device->IsNull()) {
            NPT_String channel("Master");
            int result;
            if (muted == true) {
                result = mMediaController->SetMute(*device, 0, channel, true, NULL);
            }
            else {
                result = mMediaController->SetMute(*device, 0, channel, false, NULL);
            }
            
            if (result < 0) {
                if (muted == true) {
                   // [[NSNotificationCenter defaultCenter] postNotificationName:DMR_MUTE_FAILED object:@"DMR mute failed."];
                }
                else {
                   // [[NSNotificationCenter defaultCenter] postNotificationName:DMR_MUTE_FAILED object:@"DMR unmute failed."];
                }
            }
        }
    }
}

static void SetVolume(unsigned int volume)
{
    if (mDelegate) {
        NPT_String uuidStr(g_current_Uuid);
        PLT_DeviceDataReference* device;
        m_MediaRenderers.Get(uuidStr, device);
        if (device && !device->IsNull()) {
            NPT_String channel("Master");
            int result = mMediaController->SetVolume(*device, 0, channel, volume, NULL);
            if (result < 0) {
                //[[NSNotificationCenter defaultCenter] postNotificationName:DMR_VOLUME_SET_FAILED object:@"DMR volume set failed."];
            }
        }
    }
}

static void Play()
{
    if (mDelegate) {
        NPT_String uuidStr(g_current_Uuid);
        PLT_DeviceDataReference* device;
        m_MediaRenderers.Get(uuidStr, device);
        if (device && !device->IsNull()) {
            NPT_String speed("1");
            int result = mMediaController->Play(*device, 0, speed, NULL);
            if (result < 0) {
                printf("\nPlay failed.\n");
            } else {
                printf("\n####################device: %s Play Did\n", (*device)->GetFriendlyName().GetChars());
            }
        }
    }
}

static void Stop()
{
    if (mDelegate) {
        NPT_String uuidStr(g_current_Uuid);
        PLT_DeviceDataReference* device;
        m_MediaRenderers.Get(uuidStr, device);
        if (device && !device->IsNull()) {
            int result = mMediaController->Stop(*device, 0, NULL);
            if (result < 0) {
                printf("\nStop failed.\n");
            }
        }
    }
}

static void Pause()
{
    if (mDelegate) {
        NPT_String uuidStr(g_current_Uuid);
        PLT_DeviceDataReference* device;
        m_MediaRenderers.Get(uuidStr, device);
        if (device && !device->IsNull()) {
            int result = mMediaController->Pause(*device, 0, NULL);
            if (result < 0) {
                printf("\nPause failed.\n");
            }
        }
    }
}

static void Seek()
{
    if (mDelegate) {
        NPT_String uuidStr(g_current_Uuid);
        PLT_DeviceDataReference* device;
        m_MediaRenderers.Get(uuidStr, device);
        if (device && !device->IsNull()) {
            NPT_String mode("REL_TIME");
            NPT_String target("mDataManager.mCurrentPlaybackTime");
            
            int result = mMediaController->Seek(*device, 0, mode, target, NULL);
            if (result < 0) {
                // failed
            }
        }
    }
}

static void GetMediaInfo()
{
    if (mDelegate) {
        NPT_String uuidStr(g_current_Uuid);
        PLT_DeviceDataReference* device;
        m_MediaRenderers.Get(uuidStr, device);
        if (device && !device->IsNull()) {
            NPT_String mode("REL_TIME");
            
            int result = mMediaController->GetMediaInfo(*device, 0,  NULL);
            if (result < 0) {
                // failed
                printf("\nGetMediaInfo failed.\n");

            }
        }
    }
}
//GetMediaInfo

#endif

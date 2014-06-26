"use strict";

window.Wim = {
  sipHost:    '33.33.33.100',
  sslEnabled:  false
};

window.phone = {
  notify: function () { },
  notifyStats: function () { },
  notifyError: function () { },
  notifyAddCall: function () { },
  notifyVersion: function () { },
  notifyConnected: function () { },
  notifyBugReport: function () { },
  notifyRegistered: function () { },
  notifyRemoveCall: function () { },
  notifyVideoFormat: function () { },
  notifyCallbackHold: function () { },
  notifySubscription: function () { },
  notifyConfigLoaded: function () { },
  notifyRecordComplete: function () { },
  notifyCloseConnection: function () { }
};

if (navigator.mozGetUserMedia) {
  if (typeof mozRTCPeerConnection !== undefined) {
    phone.isWebRTCAvailable = true;
    phone.webrtcDetectedBrowser = 'firefox';
    window.RTCPeerConnection = mozRTCPeerConnection;
    window.RTCSessionDescription = mozRTCSessionDescription;
    phone.getUserMedia = navigator.mozGetUserMedia.bind(navigator);

    phone.attachMediaStream = function(element, stream) {
      element.mozSrcObject = stream;
      element.play();
    };

    phone.reattachMediaStream = function(to, from) {
      to.mozSrcObject = from.mozSrcObject;
      to.play();
    };

    MediaStream.prototype.getVideoTracks = function() {
      return new Array();
    };

    MediaStream.prototype.getAudioTracks = function() {
      return new Array();
    };
  }
} else if (navigator.webkitGetUserMedia) {
  if (typeof webkitRTCPeerConnection !== undefined) {
    phone.isWebRTCAvailable = true;
    phone.webrtcDetectedBrowser = 'chrome';
    window.RTCPeerConnection = webkitRTCPeerConnection;
    phone.getUserMedia = navigator.webkitGetUserMedia.bind(navigator);

    phone.attachMediaStream = function(element, stream) {
      element.src = webkitURL.createObjectURL(stream);
      element.play();
    };

    phone.reattachMediaStream = function(to, from) {
      to.src = from.src;
      element.play();
    };

    if (!webkitMediaStream.prototype.getVideoTracks) {
      webkitMediaStream.prototype.getVideoTracks = function() {
        return this.videoTracks;
      };
    }

    if (!webkitMediaStream.prototype.getAudioTracks) {
      webkitMediaStream.prototype.getAudioTracks = function() {
        return this.audioTracks;
      };
    }
  }
}

var WebRtcMediaManager = function (localVideo, remoteVideo) {
  this.peerConnection = null;
  this.peerConnectionState = 'new';
  this.remoteAudioVideoMediaStream = null;
  this.remoteVideo = remoteVideo;
  this.localVideo = localVideo;
  this.localVideo.volume = 0;
  this.isAudioMuted = 1;
  this.isVideoMuted = 1;
  // The stun server is commented to speedup WebRTC call establishment
  // this.stunServer = 'stun.l.google.com:19302';
};

WebRtcMediaManager.prototype.init = function () {
  this.hasVideo = false;
  this.peerConnection = null;
  this.peerConnectionState = 'new';
  this.remoteAudioVideoMediaStream = null;
};

WebRtcMediaManager.prototype.close = function () {
  if (this.peerConnectionState !== 'finished') {
    this.peerConnectionState = 'finished';

    if (this.peerConnection) {
      this.peerConnection.close();
      this.remoteVideo.pause();
      // This leads to GET http://fwNN.dokmatic.com/null
      //   this.remoteVideo.src = null;
    }
  }
};

WebRtcMediaManager.prototype.createPeerConnection = function () {
  var app = this, pc_config;

  if (app.stunServer !== undefined && app.stunServer.length > 0) {
    pc_config = {'iceServers': [
      {'url': 'stun:' + app.stunServer}
    ]};
  } else {
    pc_config = {'iceServers': new Array()};
  }

  this.peerConnection = new RTCPeerConnection(pc_config, {'optional': [
    {'DtlsSrtpKeyAgreement': phone.appLoader.useDTLS}
  ]});

  this.peerConnection.onaddstream = function (event) {
    app.onOnAddStreamCallback(event);
  };

  this.peerConnection.onremovestream = function (event) {
    app.onOnRemoveStreamCallback(event);
  };
};

WebRtcMediaManager.prototype.onOnAddStreamCallback = function (event) {
  if (this.peerConnection !== null) {
    this.remoteAudioVideoMediaStream = event.stream;
    phone.attachMediaStream(this.remoteVideo, this.remoteAudioVideoMediaStream);
  }
};

WebRtcMediaManager.prototype.onOnRemoveStreamCallback = function (event) {
  if (this.peerConnection !== null) {
    this.remoteAudioVideoMediaStream = null;
    this.remoteVideo.pause();
  }
};

WebRtcMediaManager.prototype.waitGatheringIce = function () {
  var me = this, sendSdp;

  if (me.peerConnection !== null) {
    sendSdp = function () {
      if (me.peerConnection !== null) {
        if (me.peerConnection.iceGatheringState === 'complete') {
          if (me.peerConnectionState === 'preparing-offer') {
            me.peerConnectionState = 'offer-sent';
            me.createOfferCallback(me.peerConnection.localDescription.sdp);
          } else if (me.peerConnectionState === 'preparing-answer') {
            me.peerConnectionState = 'established';
            me.createAnswerCallback(me.peerConnection.localDescription.sdp);
          }
          clearInterval(me.iceIntervalId);
        }
      } else {
        clearInterval(me.iceIntervalId);
      }
    };
    me.iceIntervalId = setInterval(sendSdp, 500);
  }
};

WebRtcMediaManager.prototype.getAccessToAudioAndVideo = function () {
  var me = this;

  if (!me.localAudioVideoStream) {
    phone.getUserMedia({audio: true, video: true}, function (stream) {
      phone.attachMediaStream(me.localVideo, stream);
      me.localAudioVideoStream = stream;
      me.isAudioMuted = -1;
      me.isVideoMuted = -1;
    }, function (error) { me.isAudioMuted = 1; me.isVideoMuted = 1; }
    );
  }
};

WebRtcMediaManager.prototype.getAccessToAudio = function () {
  var me = this;

  if (!me.localAudioStream) {
    phone.getUserMedia({audio: true}, function (stream) {
      me.localAudioStream = stream;
      me.isAudioMuted = -1;
    }, function (error) { me.isAudioMuted = 1; }
    );
  }
};

WebRtcMediaManager.prototype.createOffer = function (createOfferCallback, hasVideo) {
  var me = this;

  try {
    if (me.getConnectionState() !== 'established') {
      me.init();
    }
    if (me.peerConnection === null) {
      me.createPeerConnection();
      if (hasVideo) {
        me.peerConnection.addStream(me.localAudioVideoStream);
      } else {
        me.peerConnection.addStream(me.localAudioStream);
      }
    }
    me.createOfferCallback = createOfferCallback;
    me.peerConnection.createOffer(function (offer) {
      me.onCreateOfferSuccessCallback(offer);
    }, function (error) {
      me.onCreateOfferErrorCallback(error);
    });
  } catch (exception) {
    console.log(exception);
  }
};

WebRtcMediaManager.prototype.createAnswer = function (createAnswerCallback, hasVideo) {
  var me = this;

  if (me.getConnectionState() !== 'established') {
    me.init();
  }
  try {
    if (me.peerConnection === null) {
      me.createPeerConnection();
      if (hasVideo) {
        me.peerConnection.addStream(me.localAudioVideoStream);
      } else {
        me.peerConnection.addStream(me.localAudioStream);
      }
    } else {
      if (hasVideo) {
        me.peerConnection.addStream(me.localVideoStream);
        me.hasVideo = true;
      } else {
        if (me.localVideoStream) {
          me.peerConnection.removeStream(me.localVideoStream);
        }
        me.hasVideo = false;
      }
    }
    me.createAnswerCallback = createAnswerCallback;
    var sdpOffer = new RTCSessionDescription({
      type: 'offer',
      sdp: me.lastReceivedSdp
    });
    me.peerConnectionState = 'offer-received';
    me.peerConnection.setRemoteDescription(sdpOffer, function () {
      me.onSetRemoteDescriptionSuccessCallback();
    }, function (error) {
      me.onSetRemoteDescriptionErrorCallback(error);
    });
  } catch (exception) {
    console.log(exception);
  }
};

WebRtcMediaManager.prototype.onCreateOfferSuccessCallback = function (offer) {
  if (this.peerConnection !== null) {
    if (this.peerConnectionState === 'new' || this.peerConnectionState === 'established') {
      var app = this;
      this.peerConnectionState = 'preparing-offer';
      this.peerConnection.setLocalDescription(offer, function () {
        app.onSetLocalDescriptionSuccessCallback(offer.sdp);
      }, function (error) {
        app.onSetLocalDescriptionErrorCallback(error);
      });
    }
  }
};

WebRtcMediaManager.prototype.onSetLocalDescriptionSuccessCallback = function (sdp) {
  if (phone.webrtcDetectedBrowser === 'firefox') {
    if (this.peerConnectionState === 'preparing-offer') {
      this.peerConnectionState = 'offer-sent';
      this.createOfferCallback(sdp);
    } else if (this.peerConnectionState === 'preparing-answer') {
      this.peerConnectionState = 'established';
      this.createAnswerCallback(sdp);
    }
  } else {
    this.waitGatheringIce();
  }
};

WebRtcMediaManager.prototype.getConnectionState = function () {
  return this.peerConnectionState;
};

WebRtcMediaManager.prototype.setRemoteSDP = function (sdp, isInitiator) {
  if (isInitiator) {
    var sdpAnswer = new RTCSessionDescription({
      type: 'answer',
      sdp: sdp
    });
    var app = this;
    this.peerConnectionState = 'answer-received';
    this.peerConnection.setRemoteDescription(sdpAnswer, function () {
      app.onSetRemoteDescriptionSuccessCallback();
    }, function (error) {
      app.onSetRemoteDescriptionErrorCallback(error);
    });
  } else {
    this.lastReceivedSdp = sdp;
  }
};

WebRtcMediaManager.prototype.onSetRemoteDescriptionSuccessCallback = function () {
  if (this.peerConnection !== null) {
    if (this.peerConnectionState === 'answer-received') {
      this.peerConnectionState = 'established';
    }
    else if (this.peerConnectionState === 'offer-received') {
      var app = this;
      this.peerConnection.createAnswer(function (answer) {
        app.onCreateAnswerSuccessCallback(answer);
      }, function (error) {
        app.onCreateAnswerErrorCallback(error);
      });
    }
  }
};

WebRtcMediaManager.prototype.onCreateAnswerSuccessCallback = function (answer) {
  if (this.peerConnection !== null) {
    if (this.peerConnectionState === 'offer-received') {
      var app = this;
      this.peerConnectionState = 'preparing-answer';
      this.peerConnection.setLocalDescription(answer, function () {
        app.onSetLocalDescriptionSuccessCallback(answer.sdp);
      }, function (error) {
        app.onSetLocalDescriptionErrorCallback(error);
      });
    }
  }
};

WebRtcMediaManager.prototype.setStunServer = function (server) {
  this.stunServer = server;
};

WebRtcMediaManager.prototype.requestStats = function () {
  var me = this;

  if (this.peerConnection && this.peerConnection.getRemoteStreams()[0] && phone.webrtcDetectedBrowser === 'chrome') {
    if (this.peerConnection.getStats) {
      this.peerConnection.getStats(function (rawStats) {
        var results = rawStats.result();
        var result = {};
        for (var i = 0; i < results.length; ++i) {
          var resultPart = me.processRtcStatsReport(results[i]);
          if (resultPart !== null) {
            if (resultPart.type === 'googCandidatePair') {
              result.activeCandidate = resultPart;
            } else if (resultPart.type === 'ssrc') {
              if (resultPart.packetsLost === -1) {
                result.outgoingStream = resultPart;
              } else {
                result.incomingStream = resultPart;
              }
            }
          }
        }
        phone.notifyStats(result);
      }, function(error) {
      });
    }
  }
};

WebRtcMediaManager.prototype.processRtcStatsReport = function (report) {
  var gotResult = false;
  var result = null;

  if (report.type && report.type === 'googCandidatePair') {
    if (report.stat('googActiveConnection') === 'true') {
      gotResult = true;
    }
  }

  if (report.type && report.type === 'ssrc') {
    gotResult = true;
  }

  if (gotResult) {
    result = {};
    result.timestamp = report.timestamp;
    result.id = report.id;
    result.type = report.type;
    if (report.names) {
      var names = report.names();
      for (var i = 0; i < names.length; ++i) {
        var attrName = names[i];
        result[attrName] = report.stat(attrName);
      }
    }
  }
  return result;
};

WebRtcMediaManager.prototype.onCreateAnswerErrorCallback = function (error) {
};

WebRtcMediaManager.prototype.onCreateOfferErrorCallback = function (error) {
};

WebRtcMediaManager.prototype.onSetLocalDescriptionErrorCallback = function (error) {
};

WebRtcMediaManager.prototype.onSetRemoteDescriptionErrorCallback = function (error) {
};

WebRtcMediaManager.prototype.hasActiveAudioStream = function () {
  if (!this.remoteAudioVideoMediaStream){
    return false;
  }
  var len = this.remoteAudioVideoMediaStream.getAudioTracks().length;
  if (len){
    return true;
  }else{
    return false;
  }
};

var WebSocketManager = function (localVideo, remoteVideo) {
  var me = this;
  me.isOpened = false;
  me.calls = new Array();
  me.configLoaded = false;
  me.stripCodecs = new Array();

  me.webRtcMediaManager = new WebRtcMediaManager(localVideo, remoteVideo);
  var rtcManager = this.webRtcMediaManager;

  var proccessCall = function (call) {
    for (var i in me.calls) {
      if (me.calls.hasOwnProperty(i) && call.id === me.calls[i].id) {
        me.calls[i] = call;
        return;
      }
    }
    me.calls.push(call);
    phone.notifyAddCall(call);
  };

  var getCall = function (callId) {
    for (var i in me.calls) {
      if (me.calls.hasOwnProperty(i) && callId === me.calls[i].id) {
        return me.calls[i];
      }
    }
  };

  var removeCall = function (callId) {
    for (var i in me.calls) {
      if (me.calls.hasOwnProperty(i) && callId === me.calls[i].id) {
        me.calls.splice(i, 1);
      }
    }
    if (me.calls.length === 0) {
      rtcManager.close();
    }
  };

  this.callbacks = {
    ping: function () {
      me.webSocket.send('pong');
    },

    getUserData: function (user) {
      me.user = user;
      phone.notifyConnected();
    },

    getVersion: function (version) {
      phone.notifyVersion(version);
    },

    registered: function (sipHeader) {
      phone.notifyRegistered(sipHeader);
    },

    notifyTryingResponse: function (call, sipHeader) {
      proccessCall(call);
    },

    ring: function (call, sipHeader) {
      proccessCall(call);
      phone.notify(call);
    },

    sessionProgress: function (call, sipHeader) {
      proccessCall(call);
      phone.notify(call);
    },

    setRemoteSDP: function (call, sdp, isInitiator, sipHeader) {
      proccessCall(call);
      rtcManager.setRemoteSDP(sdp, isInitiator);
      if (!isInitiator && rtcManager.getConnectionState() === 'established') {
        me.answer(call.id);
      }
    },

    talk: function (call, sipHeader) {
      proccessCall(call);
      phone.notify(call);
    },

    hold: function (call, sipHeader) {
      proccessCall(call);
      phone.notify(call);
    },

    callbackHold: function (callId, isHold) {
      var call = getCall(callId);
      phone.notifyCallbackHold(call, isHold);
    },

    finish: function (call, sipHeader) {
      proccessCall(call);
      phone.notify(call);
      phone.notifyRemoveCall(call);
      removeCall(call.id);
    },

    busy: function (call, sipHeader) {
      proccessCall(call);
      phone.notify(call);
    },

    fail: function (errorCode, sipHeader) {
      phone.notifyError(errorCode);
    },

    notifyVideoFormat: function (videoFormat) {
      phone.notifyVideoFormat(videoFormat);
    },

    notifyBugReport: function (filename) {
      phone.notifyBugReport(filename);
    },

    notifyMessage: function (message, notificationResult, sipObject) {
      messenger.notifyMessage(message, notificationResult, sipObject);
    },

    notifyAudioCodec: function (codec) {
    },

    notifyRecordComplete: function (reportObject) {
      phone.notifyRecordComplete(reportObject);
    },

    notifySubscription: function (subscriptionObject, sipObject) {
      phone.notifySubscription(subscriptionObject, sipObject);
    },

    notifyXcapResponse: function (xcapResponse) {
      notifyXcapResponse(xcapResponse);
    }
  };
};


WebSocketManager.prototype = {

  login: function (hash) {
    var me = this;

    hash.port = 5060;
    hash.useProxy = true;
    hash.domain = Wim.sipHost;
    hash.registerRequired = false;
    hash.outboundProxy = '127.0.0.1';
    hash.authenticationName = hash.login;
    hash.useDTLS = phone.appLoader.useDTLS;

    me.webSocket = $.websocket(phone.appLoader.urlServer, {
      open: function () {
        me.isOpened = true;
        me.webSocket.send('connect', hash);
      },
      close: function (event) {
        me.isOpened = false;
        if (!event.originalEvent.wasClean) {
          phone.notifyError();
        }
        phone.notifyCloseConnection();
        me.webRtcMediaManager.close();
      },
      error: function () { },
      context: me,
      events: me.callbacks
    });
  },

  logoff: function () {
    this.webSocket.close();
  },

  subscribe: function (subscribeObject) {
    this.webSocket.send('subscribe', subscribeObject);
  },

  sendXcapRequest: function (xcapUrl) {
    this.webSocket.send('sendXcapRequest', xcapUrl);
  },

  call: function (to) {
    var me = this;
    var callRequest = {
      callee: to,
      isMsrp: false,
      hasVideo: false,
      visibleName: phone.app.getInfoAboutMe().login
    };

    this.webRtcMediaManager.createOffer(function (sdp) {
      if (me.stripCodecs.length) {
        sdp = me.stripCodecsSDP(sdp);
      }
      sdp = me.removeCandidatesFromSDP(sdp);
      callRequest.sdp = sdp;
      me.webSocket.send('call', callRequest);
    }, callRequest.hasVideo);
  },

  setSendVideo: function (callId, hasVideo) {
    // var me = this;
    // this.webRtcMediaManager.createOffer(function (sdp) {
    //   me.webSocket.send('changeMediaRequest', {callId: callId, sdp: sdp});
    // }, hasVideo);
  },

  answer: function (callId, hasVideo) {
    var me = this;
    if (this.webRtcMediaManager.lastReceivedSdp !== null && this.webRtcMediaManager.lastReceivedSdp.length === 0) {
      this.webRtcMediaManager.createOffer(function (sdp) {
        if (me.stripCodecs.length) {
          sdp = me.stripCodecsSDP(sdp);
        }
        sdp = me.removeCandidatesFromSDP(sdp);
        me.webSocket.send('answer', {callId: callId, hasVideo: hasVideo, sdp: sdp});
      }, hasVideo);
    } else {
      this.webRtcMediaManager.createAnswer(function (sdp) {
        me.webSocket.send('answer', {callId: callId, hasVideo: hasVideo, sdp: sdp});
      }, hasVideo);
    }
  },

  hangup: function (callId) {
    if (callId) {
      this.webSocket.send('hangup', callId);
    }
  },

  setStatusHold: function (callId, isHold) {
    this.webSocket.send('hold', {callId: callId, isHold: isHold});
  },

  transfer: function (callId, callee) {
    this.webSocket.send('transfer', {callId: callId, callee: callee});
  },

  sendDTMF: function (callId, dtmf) {
    this.webSocket.send('sendDtmf', {callId: callId, dtmf: dtmf});
  },

  setUseProxy: function (useProxy) {
    if (this.isOpened) {
      this.webSocket.send('setUseProxy', useProxy);
    }
  },

  pushLogs: function (logs) {
    if (this.isOpened) {
      this.webSocket.send('pushLogs', logs);
      return true;
    } else {
      return false;
    }
  },

  getAccessToAudioAndVideo: function () {
    this.webRtcMediaManager.getAccessToAudioAndVideo();
  },

  getAccessToAudio: function () {
    this.webRtcMediaManager.getAccessToAudio();
  },

  getVolume: function () {
    return this.webRtcMediaManager.remoteVideo.volume * 100;
  },

  setVolume: function (value) {
    this.webRtcMediaManager.remoteVideo.volume = value / 100;
  },

  hasAccessToAudio: function () {
    return this.webRtcMediaManager.isAudioMuted === -1;
  },

  hasAccessToVideo: function () {
    return this.webRtcMediaManager.isVideoMuted === -1;
  },

  hasActiveAudioStream: function(){
    return this.webRtcMediaManager.hasActiveAudioStream();
  },

  getInfoAboutMe: function () {
    return this.user;
  },

  notificationResult: function (result) {
    this.webSocket.send('notificationResult', result);
  },

  getStats: function () {
    this.webRtcMediaManager.requestStats();
  },

  setStripCodecs: function (array) {
    this.stripCodecs = array;
  },

  removeCandidatesFromSDP: function (sdp) {
    var sdpArray = sdp.split("\n");

    for (var i = 0; i < sdpArray.length; i++) {
      if (sdpArray[i].search('a=candidate:') !== -1) {
        sdpArray[i] = "";
      }
    }

    var result = "";
    for (var i = 0; i < sdpArray.length; i++) {
      if (sdpArray[i] !== "") {
        result += sdpArray[i] + "\n";
      }
    }

    return result;
  },

  stripCodecsSDP: function (sdp) {
    var sdpArray = sdp.split("\n");

    var pt = new Array();
    for (var p = 0; p < this.stripCodecs.length; p++) {
      for (var i = 0; i < sdpArray.length; i++) {
        if (sdpArray[i].search(this.stripCodecs[p]) !== -1 && sdpArray[i].indexOf('a=rtpmap') === 0) {
          pt.push(sdpArray[i].match(/[0-9]+/)[0]);
          sdpArray[i] = "";
        }
      }
    }

    if (pt.length) {
      for (var p = 0; p < pt.length; p++) {
        for (var i = 0; i < sdpArray.length; i++) {
          if (sdpArray[i].search('a=fmtp:' + pt[p]) !== -1) {
            sdpArray[i] = "";
          }
          if (sdpArray[i].search('a=candidate:') !== -1) {
            sdpArray[i] = "";
          }
        }
      }

      for (var i = 0; i < sdpArray.length; i++) {
        if (sdpArray[i].search('m=audio') !== -1) {
          var mLineSplitted = sdpArray[i].split(' ');
          var newMLine = "";
          for (m = 0; m < mLineSplitted.length; m++) {
            if (pt.indexOf(mLineSplitted[m]) === -1 || m <= 2) {
              newMLine += mLineSplitted[m];
              if ( m < mLineSplitted.length-1 ){
                newMLine = newMLine + ' ';            
              }
            }                        
          }
          sdpArray[i]=newMLine;
          break;
        }
      }
    }

    var result = "";
    for (var i = 0; i < sdpArray.length; i++) {
      if (sdpArray[i] !== "") {
        result += sdpArray[i] + "\n";
      }
    }

    return result;
  },

  setStunServer: function (server) {
    this.webRtcMediaManager.setStunServer(server);
  }
};

var DefaultListener = function () {
};

DefaultListener.prototype = {
  onCall: function () { },
  onError: function () { },
  onHangup: function () { },
  onRegistered: function () { },
  onRemoveCall: function () { },
  onAnswer: function (callId) { },
  onIncomingCall: function (callId) { }
};

var PhoneAppLoader = function () {
  this.app = null;
  this.useDTLS = true;
  this.xcapUrl = null;
  this.stunServer = ''
  this.wsPort = '8080';
  this.wssPort = '8443';
  this.useWebRTC = true;
  this.urlServer = null;
  this.videoWidth = 352;
  this.videoHeight = 288;
  this.wcsIP = Wim.sipHost;
  this.appName = 'phone_app';
  this.useWss = Wim.sslEnabled;
  this.registerRequired = false;
  this.stripCodecs = new Array();
  this.appListener = new DefaultListener();
};

PhoneAppLoader.prototype = {
  loadAPI: function () {
    var me = this;
    var protocol = 'ws://';
    var port = this.wsPort;

    me.useWebRTC = true;

    if (this.useWss){
      protocol = 'wss://';
      port = this.wssPort;
    }

    me.urlServer = protocol + this.wcsIP + ':' + port + '/' + this.appName;
    me.app = new WebSocketManager($('#localVideo')[0], $('#remoteVideo')[0]);

    if (me.stripCodecs.length) me.app.setStripCodecs(me.stripCodecs);
    if (me.stunServer !== "") me.app.setStunServer(me.stunServer);

    phone.app = me.app;
    phone.appListener = me.appListener;

    phone.notifyConfigLoaded();
  }
};

// BOOT
//
phone.appLoader = new PhoneAppLoader();
phone.appLoader.loadAPI();

use super::*;
use crate::RemoteResult;

#[derive(Encode, Decode, Debug, PartialEq, Eq, Clone)]
pub enum LayerUdpOutgoing {
    Connect(LayerConnect),
    Write(LayerWrite),
    Close(LayerClose),
}

#[derive(Encode, Decode, Debug, PartialEq, Eq, Clone)]
pub enum DaemonUdpOutgoing {
    Connect(RemoteResult<DaemonConnect>),
    Read(RemoteResult<DaemonRead>),
    Close(ConnectionId),
}

#[derive(Encode, Decode, Debug, PartialEq, Eq, Clone)]
pub struct SendMsgResponse {
    pub sent_amount: u64,
}

#[derive(Encode, Decode, Debug, PartialEq, Eq, Clone)]
pub struct SendMsgRequest {
    pub message: String,
    pub addr: String,
    pub bound: bool,
}

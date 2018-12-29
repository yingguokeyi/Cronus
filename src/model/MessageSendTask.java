package model;

import action.service.BaseService;
import cache.ResultPoor;
import common.BaseCache;

import java.time.LocalDateTime;

public class MessageSendTask extends BaseService implements Runnable{

    @Override
    public void run() {
        String time= BaseCache.getTIME();
        int uid = sendObjectCreate(475,time);
        String res = ResultPoor.getResult(uid);
        System.out.println(" --------------  消息延迟发送任务  ------------------ " + LocalDateTime.now());

    }
}

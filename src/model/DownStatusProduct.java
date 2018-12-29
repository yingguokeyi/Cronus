package model;

import action.service.BaseService;
import cache.ResultPoor;
import common.BaseCache;

import java.time.LocalDateTime;

/**
 * @author cuiw
 * 此类是具体执行任务
 * 下架秒杀和普通专区的商品
 *
 */
public class DownStatusProduct extends BaseService implements Runnable {
	@Override
	public void run() {
			String time= BaseCache.getTIME();
			int uid = sendObjectCreate(445,time);
			String res = ResultPoor.getResult(uid);
			System.out.println(" --------------  商品下架 每刻任务  ------------------ " + LocalDateTime.now());

	}
}

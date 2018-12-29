package Timer;

import action.service.BaseService;
import cache.ResultPoor;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import common.BaseCache;
import common.kuaidi.Result;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;

public class TimerTest extends BaseService {

	public static String getStatus() {
		System.out.println("***你的小可爱来处理流转的订单状态喽***");
		int getStatus = sendObject(130);
		String rsSta = ResultPoor.getResult(getStatus);
		JSONObject jsonObject = JSONObject.parseObject(rsSta);
		JSONObject results = jsonObject.getJSONObject("result");
		JSONArray us = results.getJSONArray("rs");
		for (int i = 0; i < us.size(); i++) {
			System.out.println("####################################");
			JSONObject jsonTemp = (JSONObject) us.getJSONObject(i);
			String str = jsonTemp.getString("submission_time").toString();
			String strStatus = jsonTemp.getString("status").toString();
			String id = jsonTemp.getString("id").toString();
			if (str != null && !str.equals("")) {
				long submissionDate = Long.valueOf(jsonTemp.getString("submission_time"));
				long now = Long.valueOf(BaseCache.getDateTime());
				//180508113500  18-05-08 11:35:00    超过7天变成：已签收/已收货（107）
				if ("106".equals(strStatus) && now - 700000 >= submissionDate ) {
					sendObjectCreate(128, id);
				}
				// 超过7天变成 已完成（108）
				if ("107".equals(strStatus)&& now - 700000 >= submissionDate ) {
					sendObjectCreate(129, id);
				}
				// 超过7天变成 关闭（120）
				if ("108".equals(strStatus)&& now - 700000 >= submissionDate ) {
					sendObjectCreate(133, id);
				}
			}
		}
		return rsSta;
	}

	/**
	 * 商品超过预期销售时间自动下架
	 */
	public static void updateShelfState(){
		System.out.println("***你的小可爱来下架商品喽***");
		//生成当前时间
		String time= BaseCache.getTIME();
		//根据是否到达预售时间，下架sku
		sendObjectCreate(401,time);
		//sku下架后再全部检查对应spu的sku是否全部下架，如果全部下级，下降spu
		sendObjectCreate(402);
	}

	/**
	 * 顶级：奖励;	父级：佣金;	子级：返现
	 * b_commission表profit_source来源		1:奖励 ; 2,佣金 ； 3：返现
	 * 佣金有计算波动的订单状态：已支付：103   插入操作
	 *                       待付款状态取消订单（手动取消）110	申请退款已确认（线下申请售后）111	已取消订单（售后）113
	 *                       已关闭（确保用户不能退货）：120 确定有效
	 * b_commission表statu		0：预估佣金 	1：取消佣金  	2：实际佣金 	3：提现佣金
	 */

	public static void commissionsLoad(){
		//计算拼多多订单返佣
		pddCommission();

		//计算掌小龙平台内部订单返现
		//commissions();

		//计算掌小龙回填单收益
		//zdzCommission();
	}
	public static void commissions(){
		System.out.println("***你的小可爱来算佣金喽***");
		//生成当前时间
		String time= BaseCache.getTIME();

		//计算已支付103 没有核算过的情况
		int unCommissions = sendObject(135);
		String unCommissionsStr = ResultPoor.getResult(unCommissions);
		JSONArray unOrderList = JSONObject.parseObject(unCommissionsStr).getJSONObject("result").getJSONArray("rs");
		for (int i = 0; i < unOrderList.size(); i++) {
			JSONObject jsonTemp = unOrderList.getJSONObject(i);
			int status = jsonTemp.getString("status").equals("")?0:Integer.valueOf(jsonTemp.getString("status"));
			String orderId = jsonTemp.getString("id");
			int profit = jsonTemp.getString("profit").equals("")?0:Integer.valueOf(jsonTemp.getString("profit"));

			int outsiderTop = jsonTemp.getString("outsider_top").equals("")?0:Integer.valueOf(jsonTemp.getString("outsider_top"));
			int outsiderParent = jsonTemp.getString("outsider_parent").equals("")?0:Integer.valueOf(jsonTemp.getString("outsider_parent"));
			int outsiderSelf = jsonTemp.getString("outsider_self").equals("")?0:Integer.valueOf(jsonTemp.getString("outsider_self"));

			int memberTop = jsonTemp.getString("member_top").equals("")?0:Integer.valueOf(jsonTemp.getString("member_top"));
			int memberParent = jsonTemp.getString("member_parent").equals("")?0:Integer.valueOf(jsonTemp.getString("member_parent"));
			int memberSelf = jsonTemp.getString("member_self").equals("")?0:Integer.valueOf(jsonTemp.getString("member_self"));
			int myIsMember = jsonTemp.getString("my_is_member").equals("")?0:Integer.valueOf(jsonTemp.getString("my_is_member"));

			//存在无父级情况下,父级和顶级会员级别和会员级别和id不可以避免为空的情况,下单时候留到算佣金时处理,三元运算符解决该问题
			//topId		supIsMember   	topIsMember
			int supIsMember = jsonTemp.getString("sup_is_member").equals("")?0:Integer.valueOf(jsonTemp.getString("sup_is_member"));
			int topIsMember = jsonTemp.getString("top_is_member").equals("")?0:Integer.valueOf(jsonTemp.getString("top_is_member"));
			int topId = jsonTemp.getString("top_id").equals("")?0:Integer.valueOf(jsonTemp.getString("top_id"));
			int parentId = jsonTemp.getString("parent_id").equals("")?0:Integer.valueOf(jsonTemp.getString("parent_id"));
			int buyerId = jsonTemp.getString("buyer_id").equals("")?0:Integer.valueOf(jsonTemp.getString("buyer_id"));

			//不同的订单状态时刻
			int money = 0;
			int supMoney = 0;
			int topMoney = 0;

			//确认用户支付成功或用户点击确定收货，开始计算预估金额
			if (status == 102 || status == 103||status == 108) {
				//采用事物方式：一起提交减少通道的占用
				ArrayList<Object> ay = new ArrayList<>();
				String sql1 = "INSERT INTO uranus.b_commission (beneficiary_id,money,order_id,status,memo,profit_source,create_time) VALUES (?,?,?,?,?,?,?)";
				String sql2 = "UPDATE uranus.b_order set If_Commission = 1 where id = ?";
				if(buyerId !=0){
					if(myIsMember==0){
						money = profit*outsiderSelf;
					}else{
						money = profit*memberSelf;
					}
					ay = addTransJa(ay,sql1,buyerId,money,orderId,0,"",3,time);
					//加入钱包
					//addUserWallet(buyerId,money,time);
				}

				if(parentId != 0){
					if(supIsMember==0){
						supMoney = profit*outsiderParent;
					}else{
						supMoney = profit*memberParent;
					}
					ay = addTransJa(ay,sql1,parentId,supMoney,orderId,0,"",2,time);
				}

                if(topId != 0){
					if(topIsMember==0){
						topMoney = profit*outsiderTop;
					}else{
						topMoney = profit*memberTop;
					}
					ay = addTransJa(ay,sql1,topId,topMoney,orderId,0,"",1,time);
				}
				//订单佣金计算完毕，修改订单修改状态，避免重复计算
				ay = addTransJa(ay,sql2,orderId);
				//用事物的方式一起发送sql,减少通道的频繁占用
				sendTransJa(ay);
			}
	    }

		//更新  已经核算过的情况
		int commissions = sendObject(139);
		String commissionsStr = ResultPoor.getResult(commissions);
		JSONArray orderList = JSONObject.parseObject(commissionsStr).getJSONObject("result").getJSONArray("rs");
		for (int x = 0;  x< orderList.size(); x++) {
			JSONObject jsonTemps = orderList.getJSONObject(x);
			int status1 = Integer.valueOf(jsonTemps.getString("status"));
			String orderId1 = jsonTemps.getString("id");
			String buyerId = jsonTemps.getString("buyer_id");
			int memberSelf = jsonTemps.getString("member_self").equals("")?0:Integer.valueOf(jsonTemps.getString("member_self"));
			int myIsMember = jsonTemps.getString("my_is_member").equals("")?0:Integer.valueOf(jsonTemps.getString("my_is_member"));
			int outsiderSelf = jsonTemps.getString("outsider_self").equals("")?0:Integer.valueOf(jsonTemps.getString("outsider_self"));
			int profit = jsonTemps.getString("profit").equals("")?0:Integer.valueOf(jsonTemps.getString("profit"));
			int totalPreIncome = 0;
			if(myIsMember==0){
				totalPreIncome = profit*outsiderSelf;
			}else{
				totalPreIncome = profit*memberSelf;
			}
			//待付款状态取消订单（手动取消）110	申请退款已确认（线下申请售后）111	已取消订单（售后）113，修改佣金计算状态
			if (status1 == 110||status1 == 111|| status1 == 113) {
				sendObjectCreate(137,1,orderId1);
				//扣除预估佣金
				//subtractUserMoney(buyerId,totalPreIncome);
			}
			//订单正常关闭，预估佣金变成实际佣金
			if (status1 == 120) {
				sendObjectCreate(137,2,orderId1);
				//扣除用户预估佣金增加实际可提现佣金
				//addUserMoney(buyerId,totalPreIncome);

			}
		}
	}

	//创建用户钱包或更新用户预估金额
	public static void addUserWallet(int userId,int totalPreIncomes,String time){
		JSONArray userWallets = getUserWallet(userId);
		//有记录则更新 无记录则添加
		if(userWallets.size()>0){
			JSONObject userWallet = userWallets.getJSONObject(0);
			String totalPreIncome = userWallet.getString("totalPreIncome");
			String original_wetCat_money = userWallet.getString("wetCat_money");
			BigDecimal endtotalPreIncome = moneyAdd(new BigDecimal(totalPreIncome), new BigDecimal(totalPreIncomes));
			BigDecimal wetCat_money = moneyAdd(new BigDecimal(original_wetCat_money), new BigDecimal(totalPreIncomes));
			sendObjectCreate(618, endtotalPreIncome.toString(), wetCat_money.toString(), userId);
		}else {
			sendObjectCreate(617,userId,0,totalPreIncomes,0,0,time);
		}
	}
	//用户取消订单后扣减用户预算佣金
	public static void subtractUserMoney(String userId,int totalPreIncome){
		JSONArray userWallet = getUserWallet(Integer.valueOf(userId));
		JSONObject jsonObject = userWallet.getJSONObject(0);
		String originalMoney = jsonObject.getString("money");
		String endMoney = moneySub(String.valueOf(originalMoney), String.valueOf(totalPreIncome));
		sendObjectCreate(618,endMoney,userId);
	}
	//用户订单完成扣除用户预估佣金并更新用户余额
	public static void addUserMoney(String userId,int totalPreIncome){
		JSONArray userWallet = getUserWallet(Integer.valueOf(userId));
		JSONObject jsonObject = userWallet.getJSONObject(0);
		String totalPreIncomes = jsonObject.getString("totalPreIncome");
		String money = jsonObject.getString("money");
		BigDecimal endMoney = moneyAdd(new BigDecimal(totalPreIncome), new BigDecimal(money));
		String original_wetCat_money = jsonObject.getString("wetCat_money");
		String endwetCatMoney = moneySub(original_wetCat_money, String.valueOf(totalPreIncome));
		String endtotalPreIncome = moneySub(totalPreIncomes, String.valueOf(totalPreIncome));
		sendObjectCreate(619,endtotalPreIncome,endMoney.toString(),endwetCatMoney,userId);
	}

	//计算掌小龙的预估金额和实际可提现金额
	public static void zdzCommission(){
		//生成当前时间
		String time= BaseCache.getTIME();
		//预估金额
		int sid = sendObject(622,0,1);
		String zdzOrderList = ResultPoor.getResult(sid);
		JSONArray jsonArray = JSONObject.parseObject(zdzOrderList).getJSONObject("result").getJSONArray("rs");
		for (int i = 0; i < jsonArray.size(); i++) {
			JSONObject zdzOrder = jsonArray.getJSONObject(i);
			String userId = zdzOrder.getString("user_id");
			String id = zdzOrder.getString("id");
			String orderPreIncome = zdzOrder.getString("member_self_money");
			JSONArray userWallets = getUserWallet(Integer.valueOf(userId));
				//有记录则更新 无记录则添加
				if(userWallets.size()>0){
					JSONObject userWallet = userWallets.getJSONObject(0);
					String totalPreIncomes = userWallet.getString("totalPreIncome");
					String zdzPreIncomes = userWallet.getString("zdz_money");
					//增加预计可提现金额
					BigDecimal endPreIncome = moneyAdd(new BigDecimal(totalPreIncomes), new BigDecimal(orderPreIncome));
					//增加掌小龙累积收益金额
					BigDecimal zdzPreIncome = moneyAdd(new BigDecimal(zdzPreIncomes), new BigDecimal(orderPreIncome));
					sendObjectCreate(620, endPreIncome.toString(), zdzPreIncome.toString(),userId);
				}else {
					//增加新用户钱包
					sendObjectCreate(617,userId,0,orderPreIncome,orderPreIncome,0,time);
				}
			//修改掌小龙订单状态
			sendObjectCreate(623,1,id);
		}
		//可提现金额
		int sid1 = sendObject(622,1,2);
		String zdzOrderList1 = ResultPoor.getResult(sid1);
		JSONArray jsonArray1 = JSONObject.parseObject(zdzOrderList1).getJSONObject("result").getJSONArray("rs");
		for (int i = 0; i < jsonArray1.size(); i++) {
			JSONObject zdzOrder = jsonArray1.getJSONObject(i);
			String userId = zdzOrder.getString("user_id");
			String id = zdzOrder.getString("id");
			String orderPreIncome = zdzOrder.getString("member_self_money");
			JSONArray userWallets = getUserWallet(Integer.valueOf(userId));
			JSONObject userWallet = userWallets.getJSONObject(0);
			String totalPreIncomes = userWallet.getString("totalPreIncome");
			String money = userWallet.getString("money");
			//增加可提现金额
			BigDecimal endMoney = moneyAdd(new BigDecimal(orderPreIncome), new BigDecimal(money));
			//减少掌小龙回填单累积收入
			String original_zdz_money = userWallet.getString("zdz_money");
			//String endZdzMoney = moneySub(original_zdz_money, String.valueOf(orderPreIncome));
			//减少预计可提现金额
			String endtotalPreIncome = moneySub(totalPreIncomes, String.valueOf(orderPreIncome));
			sendObjectCreate(621,endMoney.toString(),endtotalPreIncome,userId);
			//修改掌小龙订单状态
			sendObjectCreate(623,2,id);
		}
		//已失效和用户退款订单
		int sid2 = sendObject(625,2,3,3);
		String zdzOrderList2 = ResultPoor.getResult(sid2);
		JSONArray jsonArray2 = JSONObject.parseObject(zdzOrderList2).getJSONObject("result").getJSONArray("rs");
		for (int i = 0; i < jsonArray2.size(); i++) {
			JSONObject zdzOrder = jsonArray2.getJSONObject(i);
			String userId = zdzOrder.getString("user_id");
			String id = zdzOrder.getString("id");
			String orderPreIncome = zdzOrder.getString("member_self_money");
			JSONArray userWallets = getUserWallet(Integer.valueOf(userId));
			JSONObject userWallet = userWallets.getJSONObject(0);
			String totalPreIncomes = userWallet.getString("totalPreIncome");
			String zdzPreIncomes = userWallet.getString("zdz_money");
			//减少预计可提现金额
			String endPreIncomes = moneySub(String.valueOf(totalPreIncomes), String.valueOf(orderPreIncome));
			//减少掌小龙回填单累积金额
			String zdz_money = moneySub(String.valueOf(zdzPreIncomes), String.valueOf(orderPreIncome));
			sendObjectCreate(620,endPreIncomes,zdz_money,userId);
			//修改掌小龙订单状态
			sendObjectCreate(623,3,id);
		}
	}

	//查询用户钱包
	public static JSONArray getUserWallet(int userId){
		int wallet = sendObject(616,userId);
		String userWallets = ResultPoor.getResult(wallet);
		return JSONObject.parseObject(userWallets).getJSONObject("result").getJSONArray("rs");
	}

	//计算pdd订单佣金
	public static void pddCommission(){
		System.out.println("***你的小可爱来算**拼多多**佣金喽***");
		//获得当前系统时间
		String time = BaseCache.getTIME();
		//查询可转换为预估佣金的订单(status:1,2)
		int sid = sendObject(639, 1, 2, 2);
		JSONArray jsonArray = JSONObject.parseObject(ResultPoor.getResult(sid)).getJSONObject("result").getJSONArray("rs");
		//计算已支付的订单加入的预估佣金
			for (int i = 0; i < jsonArray.size(); i++) {
				JSONObject pddorder = jsonArray.getJSONObject(i);
				//订单中获取必备参数：该用户、订单编号、订单佣金、用户等级、用户手机号,用户父类id
				String orderUserId = pddorder.getString("orderUserId");
				String order_sn = pddorder.getString("order_sn");
				String promotion_amount = pddorder.getString("promotion_amount");
				String member_level = pddorder.getString("member_level");
				String phone = pddorder.getString("phone");
				String parent_user_id = pddorder.getString("parent_user_id");
				//小掌柜 自我返佣50%
				if("2".equals(member_level) || "3".equals(member_level)){
					//计算后佣金金额
					String commission = moneymultiply(promotion_amount, "0.5");
					//加入钱包
					addOrUpdateUserWallet(orderUserId,commission,time);
					//记录改条订单已扫描过加入到钱包，禁止再次扫描
					sendObjectCreate(645,2,order_sn);
					//更新订单佣金
					sendObjectCreate(654,commission,order_sn);
				}else if("1".equals(member_level)){
					//普通会员查询有无上级，若有给上级返利
					if(parent_user_id !=null && !"".equals(parent_user_id)) {
						int i1 = sendObject(646, parent_user_id);
						JSONArray memberArray = JSONObject.parseObject(ResultPoor.getResult(i1)).getJSONObject("result").getJSONArray("rs");
							String parent_member_level = memberArray.getJSONObject(0).getString("member_level");
							String top_user_id = memberArray.getJSONObject(0).getString("parent_user_id");
							if ("2".equals(parent_member_level) || "3".equals(parent_member_level)) {
								//给自己的父级返佣20%
								String parentcommission = moneymultiply(promotion_amount, "0.2");
								//加入钱包
								addOrUpdateUserWallet(parent_user_id, parentcommission, time);
								//更新订单佣金
								sendObjectCreate(656,parent_user_id,parentcommission,order_sn);
							}
							if (top_user_id !=null && !"".equals(top_user_id)) {
								int i2 = sendObject(646, top_user_id);
								JSONArray memberArray1 = JSONObject.parseObject(ResultPoor.getResult(i2)).getJSONObject("result").getJSONArray("rs");
								String top_member_level = memberArray1.getJSONObject(0).getString("member_level");
								if ("3".equals(top_member_level)) {
									//给自己顶级返佣10%
									String topCommission = moneymultiply(promotion_amount, "0.1");
									//加入钱包
									addOrUpdateUserWallet(top_user_id, topCommission, time);
									//更新订单佣金
									sendObjectCreate(657,top_user_id,topCommission,order_sn);
								}
							}

					}
                    //记录改条订单已扫描过加入到钱包，禁止再次扫描
                    sendObjectCreate(645,2,order_sn);
				}
			}
		//查询审核成功可转化为可提现金额的订单佣金
		int sid1 = sendObject(639, 3, 5, 3);
		JSONArray moneyArray = JSONObject.parseObject(ResultPoor.getResult(sid1)).getJSONObject("result").getJSONArray("rs");
		//计算审核通过的订单将佣金转换为可提现金额
		for(int i=0;i<moneyArray.size();i++){
			JSONObject pddorder1 = moneyArray.getJSONObject(i);
			String orderUserId = pddorder1.getString("orderUserId");
			String order_sn = pddorder1.getString("order_sn");
			String promotion_amount = pddorder1.getString("promotion_amount");
			String member_level = pddorder1.getString("member_level");
			String phone = pddorder1.getString("phone");
			String parent_user_id = pddorder1.getString("parent_user_id");
			//小掌柜 自我返佣50%
			if("2".equals(member_level) || "3".equals(member_level)){
				//计算后佣金金额
				String commission = moneymultiply(promotion_amount, "0.5");
				//加入钱包
				updateUserWallet(orderUserId,commission,time);
				//记录改条订单已扫描过加入到钱包，禁止再次扫描
				sendObjectCreate(645,3,order_sn);
			}else if("1".equals(member_level)){
				//普通会员查询有无上级，若有给上级返利
				if(parent_user_id !=null && !parent_user_id.equals("0")) {
					int i1 = sendObject(646, parent_user_id);
					JSONArray memberArray = JSONObject.parseObject(ResultPoor.getResult(i1)).getJSONObject("result").getJSONArray("rs");
						String parent_member_level = memberArray.getJSONObject(0).getString("member_level");
						String top_user_id = memberArray.getJSONObject(0).getString("parent_user_id");
						if ("2".equals(parent_member_level) || "3".equals(parent_member_level)) {
							//给自己的父级返佣20%
							String parentcommission = moneymultiply(promotion_amount, "0.2");
							//加入钱包
							updateUserWallet(parent_user_id, parentcommission, time);
						}
						if (top_user_id != null && !"".equals(top_user_id)) {
							int i2 = sendObject(646, top_user_id);
							JSONArray memberArray1 = JSONObject.parseObject(ResultPoor.getResult(i2)).getJSONObject("result").getJSONArray("rs");
							String top_member_level = memberArray1.getJSONObject(0).getString("member_level");
							if ("3".equals(top_member_level)) {
								//给自己顶级返佣10%
								String topCommission = moneymultiply(promotion_amount, "0.1");
								//加入钱包
								updateUserWallet(top_user_id, topCommission, time);
							}
						}
				}
				//记录改条订单已扫描过加入到钱包，禁止再次扫描
				sendObjectCreate(645,3,order_sn);
			}
		}

		//查询审核失败的订单佣金
		int sid2 = sendObject(639, 4, 10, 4);
		JSONArray TotalPreIncome = JSONObject.parseObject(ResultPoor.getResult(sid2)).getJSONObject("result").getJSONArray("rs");
		//计算审核失败的订单将佣金从钱包账户相应减去
		for(int i=0;i<TotalPreIncome.size();i++){
			JSONObject pddorder1 = TotalPreIncome.getJSONObject(i);
			String orderUserId = pddorder1.getString("orderUserId");
			String order_sn = pddorder1.getString("order_sn");
			String promotion_amount = pddorder1.getString("promotion_amount");
			String member_level = pddorder1.getString("member_level");
			String phone = pddorder1.getString("phone");
			String parent_user_id = pddorder1.getString("parent_user_id");
			//小掌柜 自我返佣50%
			if("2".equals(member_level) || "3".equals(member_level)){
				//计算后佣金金额
				String commission = moneymultiply(promotion_amount, "0.5");
				//更新钱包
				updateUserWalletTotalPreIncome(orderUserId,commission,time);
				//记录改条订单已扫描过加入到钱包，禁止再次扫描
				sendObjectCreate(645,4,order_sn);
			}else if("1".equals(member_level)){
				//普通会员查询有无上级，若有给上级返利
				if(parent_user_id !=null) {
					int i1 = sendObject(646, parent_user_id);
					JSONArray memberArray = JSONObject.parseObject(ResultPoor.getResult(i1)).getJSONObject("result").getJSONArray("rs");
						String parent_member_level = memberArray.getJSONObject(0).getString("member_level");
						String top_user_id = memberArray.getJSONObject(0).getString("parent_user_id");
						if ("2".equals(parent_member_level) || "3".equals(parent_member_level)) {
							//给自己的父级返佣20%
							String parentcommission = moneymultiply(promotion_amount, "0.2");
							//更新钱包
							updateUserWalletTotalPreIncome(parent_user_id, parentcommission, time);
						}
					if (top_user_id != null && !"".equals(top_user_id)) {
						int i2 = sendObject(646, top_user_id);
						JSONArray memberArray1 = JSONObject.parseObject(ResultPoor.getResult(i2)).getJSONObject("result").getJSONArray("rs");
						String top_member_level = memberArray1.getJSONObject(0).getString("member_level");
						if ("3".equals(top_member_level)) {
							//给自己顶级返佣10%
							String topCommission = moneymultiply(promotion_amount, "0.1");
							//加入钱包
							updateUserWalletTotalPreIncome(top_user_id, topCommission, time);
						}
					}
				}
                //记录改条订单已扫描过加入到钱包，禁止再次扫描
                sendObjectCreate(645,4,order_sn);
			}
		}
		System.out.println("***拼多多订单佣金计算结束***");
	}


	/**
	 * 金额相加
	 *
	 * @param value
	 *            基础值
	 * @param augend
	 *            被加数
	 * @return
	 */
	public static BigDecimal moneyAdd(BigDecimal value, BigDecimal augend) {
		return value.add(augend);
	}

	/**
	 * 金额相减
	 *
	 * @param valueStr
	 *            基础值
	 * @param minusValueStr
	 *            减数
	 * @return
	 */
	public static DecimalFormat fnum = new DecimalFormat("##0.00");
	public static String moneySub(String valueStr, String minusStr) {
		BigDecimal value = new BigDecimal(valueStr);
		BigDecimal subtrahend = new BigDecimal(minusStr);
		return fnum.format(value.subtract(subtrahend));
	}

	/**
	 * 金额乘以百分比
	 * @param num1
	 * @param num2
	 * @return
	 */
	public static String moneymultiply(String num1,String num2) {
		BigDecimal bignum1 = new BigDecimal(num1);
		BigDecimal bignum2 = new BigDecimal(num2);
		return fnum.format(bignum1.multiply(bignum2));
	}

	/**
	 * 加入或更新用户钱包
	 * @param orderUserId
	 * @param commission
	 * @param time
	 */
	public static void addOrUpdateUserWallet(String orderUserId,String commission,String time){
		//有无钱包，有则更新，无则添加
		JSONArray userWallets = getUserWallet(Integer.valueOf(orderUserId));
		if(userWallets.size()>0){
			JSONObject userWallet = userWallets.getJSONObject(0);
			//原有累积预计可提现金额
			String totalPreIncomes = userWallet.getString("totalPreIncome");
			//原有累积总收益
			String totalIncome = userWallet.getString("totalIncome");
			//原有pdd累积收入
			String pddPreIncomes = userWallet.getString("pdd_money");
			//计算后预计可提现收入
			BigDecimal resulttotalPreIncomes = moneyAdd(new BigDecimal(totalPreIncomes), new BigDecimal(commission));
			//计算后的累积总收益
			BigDecimal resulttotalIncomes = moneyAdd(new BigDecimal(totalIncome), new BigDecimal(commission));
			//计算后pdd累积收入
			BigDecimal resultpddPreIncomes = moneyAdd(new BigDecimal(pddPreIncomes), new BigDecimal(commission));
			sendObjectCreate(647, resulttotalIncomes.toString(),resulttotalPreIncomes.toString(), resultpddPreIncomes.toString(),orderUserId);
		}else{
			sendObjectCreate(648,orderUserId,0,commission,commission,0,0,commission,time);
		}
	}

	//更新钱包可提现金额
	public static void  updateUserWallet(String orderUserId,String commission,String time) {
		//获取用户钱包原有数据
		JSONArray userWallets = getUserWallet(Integer.valueOf(orderUserId));
		if (userWallets.size() > 0) {
			JSONObject userWallet = userWallets.getJSONObject(0);
			//原有预计可提现金额
			String totalPreIncomes = userWallet.getString("totalPreIncome");
			//原有可提现金额
			String money = userWallet.getString("money");
			//计算后可提现金额
			BigDecimal resultMoney = moneyAdd(new BigDecimal(money), new BigDecimal(commission));
			//从预估佣金中减去转化为的可提现金额
			String resulttTtalPreIncomes = moneySub(totalPreIncomes, commission);
			sendObjectCreate(621, resultMoney.toString(), resulttTtalPreIncomes.toString(), orderUserId);
		}
	}

	//更新钱包预计可提现金额
	public static void updateUserWalletTotalPreIncome(String orderUserId,String commission,String time){
		//获取用户钱包原有数据
		JSONArray userWallets = getUserWallet(Integer.valueOf(orderUserId));
		if (userWallets.size() > 0) {
			JSONObject userWallet = userWallets.getJSONObject(0);
			//累积总收益金额
			String totalIncomes = userWallet.getString("totalIncome");
			//累积预计可提现金额
			String totalPreIncome = userWallet.getString("totalPreIncome");
			//pdd累积收益
			String pdd_money = userWallet.getString("pdd_money");
			//从拼多多减去审核失败的佣金金额
			String pddMoney = moneySub(pdd_money, commission);
			//从累积总收益中减去审核失败的佣金金额
			String resultTotalIncomes = moneySub(totalIncomes, commission);
			//从预估佣金中减去审核失败的佣金金额
			String resulttTtalPreIncomes = moneySub(totalPreIncome, commission);
			sendObjectCreate(647,resultTotalIncomes,resulttTtalPreIncomes,pddMoney,orderUserId);
		}
	}
}

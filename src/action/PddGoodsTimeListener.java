package action;

import action.service.BaseService;
import model.PddGoodsManager;
import model.SeckillTimeManager;
import org.apache.commons.lang3.concurrent.BasicThreadFactory;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class PddGoodsTimeListener extends BaseService implements ServletContextListener {
    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        System.out.println("-------------  contextDestroyed   ----------------");

    }

    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        System.out.println(" -------------   pddTimeListener   ---------------start tme  form  " + LocalDateTime.now());
        executeEightAtNightPerDay();
        executePddOrder();
    }

    public static void executeEightAtNightPerDay() {
        ScheduledExecutorService executorService = new ScheduledThreadPoolExecutor(
                1,
                new BasicThreadFactory.Builder().namingPattern("seckillTime-ScheduleReverse-pool-%d").daemon(true).build()
        );
        //定时执行方案 每两天晚上11点执行一次
        long oneDay = 48 * 60 * 60 * 1000;
        long initDelay = getTimeMillis("23:00:00") - System.currentTimeMillis();
        initDelay = initDelay > 0 ? initDelay : oneDay + initDelay;

        executorService.scheduleAtFixedRate(
                new PddGoodsManager(),
                initDelay,
                oneDay,
                TimeUnit.MILLISECONDS);
        //间隔固定时间段执行方案
        /*executorService.scheduleAtFixedRate(
                new PddGoodsManager(),
                1000 * 60 * 60,
                1000 * 60 * 60 * 6,
                TimeUnit.MILLISECONDS);*/

    }

    public static void executePddOrder() {
        ScheduledExecutorService executorService = new ScheduledThreadPoolExecutor(
                1,
                new BasicThreadFactory.Builder().namingPattern("pddOrder-ScheduleReverse-pool-%d").daemon(true).build()
        );
//        long oneDay = 2 * 60 * 1000;
//        long initDelay = getTimeMillis("6:00:00") - System.currentTimeMillis();
//        initDelay = initDelay > 0 ? initDelay : oneDay + initDelay;
        System.out.println(" -------------   拼多多订单定时任务   ---------------" + LocalDateTime.now());
        executorService.scheduleAtFixedRate(
                new PddOrderManager(),
                1000 * 60 * 5,
                1000 * 60 * 5,
                TimeUnit.MILLISECONDS);

    }

    /**
     * 获取指定时间对应的毫秒数
     *
     * @param time "HH:mm:ss"
     * @return
     */
    private static long getTimeMillis(String time) {
        try {
            DateFormat dateFormat = new SimpleDateFormat("yy-MM-dd HH:mm:ss");
            DateFormat dayFormat = new SimpleDateFormat("yy-MM-dd");
            Date curDate = dateFormat.parse(dayFormat.format(new Date()) + " " + time);
            return curDate.getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

package action;

import action.service.BaseService;

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

import model.DownStatusProduct;
import model.MessageSendTask;
import model.SeckillTimeManager;
import org.apache.commons.lang3.concurrent.BasicThreadFactory;

/**
 * @author cuiw
 */
public class SeckillTimeListener extends BaseService implements ServletContextListener {


    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        System.out.println("-------------  contextDestroyed   ----------------");

    }

    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        System.out.println(" -------------   contextInitialized   ---------------start tme  form  " + LocalDateTime.now());
        executeFixedDelay();
        executeEightAtNightPerDay();
        executeMessageDelay();
    }

    public static void executeMessageDelay(){
        ScheduledExecutorService executorService = new ScheduledThreadPoolExecutor(
                1,
                new BasicThreadFactory.Builder().namingPattern("MessageSendind-ScheduleDown-pool-%d").daemon(true).build()
        );
        executorService.scheduleWithFixedDelay(
                new MessageSendTask(),
                 60 * 1,
                 60 * 1,
                TimeUnit.SECONDS);
    }
    /**
     * 以固定延迟时间进行执行
     * 本次任务执行完成后，需要延迟设定的延迟时间，才会执行新的任务
     */
    public static void executeFixedDelay() {
        ScheduledExecutorService executorService = new ScheduledThreadPoolExecutor(
                1,
                new BasicThreadFactory.Builder().namingPattern("RecommonProduct-ScheduleDown-pool-%d").daemon(true).build()
        );
        executorService.scheduleWithFixedDelay(
                new DownStatusProduct(),
                1000 * 60 * 1,
                1000 * 60 * 1,
                TimeUnit.MILLISECONDS);
    }

    /**
     * 每天晚上12点执行一次
     * 每天定时安排任务进行执行
     */
    public static void executeEightAtNightPerDay() {
        ScheduledExecutorService executorService = new ScheduledThreadPoolExecutor(
                1,
                new BasicThreadFactory.Builder().namingPattern("seckillTime-ScheduleReverse-pool-%d").daemon(true).build()
        );
        long oneDay = 24 * 60 * 60 * 1000;
        long initDelay = getTimeMillis("24:00:00") - System.currentTimeMillis();
        initDelay = initDelay > 0 ? initDelay : oneDay + initDelay;

        executorService.scheduleAtFixedRate(
                new SeckillTimeManager(),
                initDelay,
                oneDay,
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

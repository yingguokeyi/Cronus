package action.sqlhelper;


import common.PropertiesConf;

public class GoodsSql {


//    public static final String getAllGoods_sql = "SELECT * FROM uranus.b_spu ";


    public static String getImageInfo(String img_id){
        StringBuffer sql = new StringBuffer("SELECT id,image_name,IF (http_path IS NOT NULL,concat('http://',http_path) ,concat('"+PropertiesConf.IMG_URL_PREFIX+"',image_path))  as image_path FROM uranus.b_image where id = ");
                    sql.append(img_id);
        return sql.toString();
    }


    public static String getGoodsPlanInfo(String uri){
        //StringBuffer sql = new StringBuffer("SELECT id,image_name,IF (http_path IS NOT NULL,concat('http://',http_path) ,concat('"+PropertiesConf.IMG_URL_PREFIX+"',image_path))  as image_path FROM uranus.b_image where id = ");


        StringBuffer sql = new StringBuffer("select P.*,(SELECT IF (http_path IS NOT NULL,concat('http://',http_path) ,concat('"+PropertiesConf.IMG_URL_PREFIX + "',image_path))    FROM b_image WHERE id = P.img_id) AS img_path   from uranus.b_plan P where uri = '");

        sql.append(uri).append("'");
        return sql.toString();
    }



    //获取单个商品SPU信息
    public static String getGoodSPU(String spu_id){
        StringBuffer sql  =  new StringBuffer("SELECT id,spu_code,spu_name,source_code,goods_url,brand_id,supplier_id,district_id,first_attribute,second_attribute,show_img_ids,detail_img_ids,status,goods_type_id,sort,detail,memo,");
                sql.append("(SELECT dict_data_name FROM s_dictionary_data WHERE dict_id = 1 and dict_data_value = P.category_id) minCateName,");
                sql.append("(SELECT dict_data_name FROM s_dictionary_data WHERE dict_id = 3 and dict_data_value = P.goods_type_id) goodTypeName,");
                sql.append("(SELECT dict_data_name FROM s_dictionary_data WHERE dict_id = 1 and dict_data_value = CONCAT(LEFT((P.category_id),6),'000')) subCateName,");
                sql.append("(SELECT dict_data_name FROM s_dictionary_data WHERE dict_id = 1 and dict_data_value = CONCAT(LEFT((P.category_id),3),'000000')) topCateName");
                sql.append(" FROM uranus.b_spu P ");
                sql.append("WHERE id =").append(spu_id);
        return sql.toString();
    }





    //获取单个商品SKU信息
    public static String getGoodSKU(String sku_id){
        StringBuffer sql = new StringBuffer("SELECT K.bounty,K.id,K.sku_code,P.spu_name,K.sku_name,P.first_attribute,K.first_attribute_id,P.second_attribute,K.second_attribute_id,K.market_price,K.original_price,");
                sql.append("K.outsider_top,K.outsider_parent,K.outsider_self,K.member_top,K.member_parent,K.member_self,K.member_distribution_id,K.outsider_distribution_id,K.stock,K.is_default,K.sku_status,K.coupon,");
                sql.append("K.distribution_begintime,K.distribution_endtime,K.presell_begintime,K.presell_endtime,K.sku_style,K.sales_volume,K.memo,");
                sql.append("(SELECT attribute_value FROM b_spu_attribute A1 WHERE K.first_attribute_id = A1.id) first_attribute_value,");
                sql.append("(SELECT attribute_value FROM b_spu_attribute A2 WHERE K.first_attribute_id = A2.id) second_attribute_value");
        sql.append(",K.buyconfine");
        sql.append(" FROM uranus.b_sku K LEFT JOIN uranus.b_spu P ON K.spu_id = P.id");
        sql.append(" WHERE K.id =").append(sku_id);
        return sql.toString();
    }


    //查询SPU下相关的SKU的起售数量
    public static String getCountStartSaleSKU(String spu_id){
        StringBuffer sql = new StringBuffer("SELECT COUNT(*) AS CNT from b_sku where sku_status=1 and spu_id = ");
                    sql.append(spu_id);
         return sql.toString();
    }


    //查询分类下相关的SPU数量（已存放数据表中 id:39）TODO
    public static String getCountSPUByCateCodeHead(String cateCodeHead){
        StringBuffer sql = new StringBuffer("SELECT COUNT(*) AS CNT from b_spu where category_id like '");
        sql.append(cateCodeHead).append("%'");
        return sql.toString();
    }


    //查询商品列表
    // 这里Where子句里不带status,使用者后按条件查询
    public static String getGoodsList(){
        StringBuffer sql = new StringBuffer("SELECT P.*,from_unixtime(P.edit_time,'%Y-%m-%d %h:%i') AS editTime,from_unixtime(P.create_time,'%Y-%m-%d %h:%i') AS createTime,T1.cnt cnt1,T2.cnt cnt2,");
                                sql.append(" (SELECT nick_name FROM t_user WHERE id = P.edit_user_id) nick_name,");
                                sql.append("(SELECT dict_data_name FROM s_dictionary_data WHERE dict_id = 1 and dict_data_value = P.category_id) cateName,");
                                sql.append("(SELECT dict_data_name FROM s_dictionary_data WHERE dict_id = 3 and dict_data_value = P.goods_type_id) goodsTypeName, ");
                                sql.append("(SELECT dict_data_name FROM s_dictionary_data WHERE dict_id = 5 and dict_data_value = P.source_code) sourceName, ");
                                sql.append("(SELECT brand_name FROM t_brand WHERE id = P.brand_id) brandName,");
                                sql.append("(SELECT supplier_name FROM t_supplier WHERE id = P.supplier_id) supplierName");
                                sql.append(" FROM uranus.b_spu P ");
                                sql.append("LEFT JOIN ");
                                sql.append("(select COUNT(position) cnt,position,spu_id from b_spu_attribute AS PA  JOIN b_spu AS spu ON PA.spu_id = spu.id GROUP BY PA.position,PA.spu_id) T1 ");
                                sql.append("ON P.id = T1.spu_id and T1.position = 1 ");
                                sql.append("LEFT JOIN ");
                                sql.append("(select COUNT(position) cnt,position,spu_id from b_spu_attribute AS PA  JOIN b_spu AS spu ON PA.spu_id = spu.id GROUP BY PA.position,PA.spu_id) T2 ");
                                sql.append("ON P.id = T2.spu_id and T2.position = 2 ");
                                //sql.append("WHERE (P.status=1 or P.status=0) ");
        return sql.toString();
    }



    //查询首页推荐列表
    public static String getPlanList(){
        StringBuffer sql = new StringBuffer("SELECT P.*,(SELECT image_path from b_image I where I.id = img_id ) img_path,");
        sql.append("(SELECT IF(P.category=1,(SELECT spu_name from uranus.b_spu where id = substring(P.uri,7)),'')) AS goods_name ");
        sql.append(" FROM uranus.b_plan P ");
        return sql.toString();
    }


    //获得单个分类的信息
    public static String getCateInfo(String cateId){
        StringBuffer sql = new StringBuffer("SELECT cate.id,cate.dict_data_name cateName,cate.memo,cate.sort,cate.image_id,(SELECT image_path from b_image WHERE id = cate.image_id) AS image_path ");
                            sql.append(" FROM uranus.s_dictionary_data cate where cate.id = ");
                            sql.append(cateId);
        return sql.toString();
    }


    //查询一级类目最大编码
    public static final String getMax_Top_Code_sql = "SELECT LEFT(max(dict_data_value),3) AS maxcode FROM uranus.s_dictionary_data where dict_id = 1";

    //查询二级分类的最大编码
    public String getMax_Sub_Code_sql(String pCateCodeHead){
        String sql = "SELECT LEFT(max(dict_data_value),6) AS maxcode FROM uranus.s_dictionary_data where dict_id = 1 and dict_data_value LIKE '"+pCateCodeHead+"%'";
        return sql;
    }

    //查询三级分类的最大编码
    public String getMax_Min_Code_sql(String pCateCodeHead){
        String sql = "SELECT max(dict_data_value) AS maxcode FROM uranus.s_dictionary_data where dict_id = 1 and dict_data_value LIKE '"+pCateCodeHead+"%'";
        return sql;
    }



    //查询一级分类列表
    public static final String getFirstCategoryList_sql = "SELECT *,(SELECT image_path from b_image I where I.id = image_id ) img_path FROM uranus.s_dictionary_data where dict_id = 1 and dict_data_value like '%000000' and state != 0 ";

    //查询二级分类列表
    public static String getSub_Cate_List_sql(String pCateCodeHead){
        StringBuffer sql =  new StringBuffer("SELECT *,(SELECT image_path from b_image I where I.id = image_id ) img_path FROM uranus.s_dictionary_data where dict_id = 1 and dict_data_value like '"+pCateCodeHead+"%000' and dict_data_value !='"+ pCateCodeHead +"000000'");
            sql.append(" and state != 0 ");
        return sql.toString();
    }

    //查询三级分类列表
    public static String getMin_Cate_List_sql(String pCateCodeHead){
        StringBuffer sql =  new StringBuffer("SELECT *,(SELECT image_path from b_image I where I.id = image_id ) img_path,(SELECT count(*) from b_spu  WHERE category_id = dict_data_value) AS GOODS_CNT FROM uranus.s_dictionary_data where dict_id = 1 and dict_data_value like '"+pCateCodeHead+"%' and dict_data_value !='"+ pCateCodeHead +"000'");
                sql.append(" and state != 0 ");

        return sql.toString();
    }



    //查询相关的分类列表（根据pCateCodeHead,不带状态）
    public String get_Cate_List_sql(String pCateCodeHead){
        StringBuffer sql =  new StringBuffer("SELECT * FROM uranus.s_dictionary_data where dict_id = 1 and dict_data_value like '"+pCateCodeHead+"%' ");

        return sql.toString();
    }




    //根据三级分类的编码，查询商品类型信息
    public static String getGoods_Type_List_sql(String pCateCodeHead){
        StringBuffer sql =  new StringBuffer("SELECT * FROM uranus.s_dictionary_data where dict_id = 3 and dict_data_value like '"+pCateCodeHead+"%' and dict_data_value !='"+ pCateCodeHead +"'");
        return sql.toString();
    }



}

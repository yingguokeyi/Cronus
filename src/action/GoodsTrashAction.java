package action;

import action.service.GoodsTrashService;
import servlet.BaseServlet;

import javax.servlet.annotation.WebServlet;

@WebServlet(name = "GoodsTrash", urlPatterns = "/goodstrash")
public class GoodsTrashAction extends BaseServlet{
	
	private static final long serialVersionUID = 1L;

	/**
	 * 商品回收站列表
	 * 2018/3/13 木易
	 * @return
	 */
	public String GoodsTrash(String spu_name,  String supplier_name , String brand_name ,String dict_data_name, String spu_code, String page,String limit) throws Exception{
		int pageI = Integer.valueOf(page);
		int limitI =Integer.valueOf(limit);

		String res = GoodsTrashService.GoodsTrash(spu_name, supplier_name ,brand_name, dict_data_name,spu_code,(pageI-1)*limitI,limitI);

		return res;
	}



	//商品回收（彻底删除）
	public String DeleteTrash(String ids) {
		String res = GoodsTrashService.DeleteTrash(ids);
		return res;
	}

	/**
	 * 商品sku回收站列表
	 * 2018/3/13 木易
	 * @return
	 */
	public String SKUGoodsTrash(String page,String limit,String id) {
		int pageI = Integer.valueOf(page);
		int limitI =Integer.valueOf(limit);
		String res = GoodsTrashService.SKUGoodsTrash((pageI-1)*limitI,limitI,id);
		return res;
	}


	//商品回收（还原）
	public String restore(String ids) {
		System.out.println(ids);
		String res = GoodsTrashService.restore(ids);
		return res;
	}
}
<%
    def varDomainName=tableNameUtil.lowerCaseFirst(tableDefine.id);
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.category,"." )}.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.category,"." )}.model.entity.${tableDefine.id}Entity;
import com.citycloud.ccuap.framework.pagination.PageQuery;

import java.util.List;
import java.util.Map;

/**
 * ${tableDefine.cnname} Service接口
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
public interface ${tableDefine.id}Service extends IService<${tableDefine.id}Entity> {

	Page<${tableDefine.id}Entity> queryListByPage(PageQuery<Map<String, Object>> pageQuery,  String sort, Boolean asc);

	List<${tableDefine.id}Entity> queryList(Map<String, Object> map);
}
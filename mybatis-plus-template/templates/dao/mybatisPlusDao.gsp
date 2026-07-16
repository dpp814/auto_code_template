<%
    def varDomainName=tableNameUtil.lowerCaseFirst(tableDefine.id);
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.category,"." )}.dao;

import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.category,"." )}.model.entity.${tableDefine.id}Entity;
import com.citycloud.ccuap.framework.mp.util.BaseDao;

/**
 * ${tableDefine.cnname} 数据访问接口
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
public interface ${tableDefine.id}Dao extends BaseDao<${tableDefine.id}Entity> {
}

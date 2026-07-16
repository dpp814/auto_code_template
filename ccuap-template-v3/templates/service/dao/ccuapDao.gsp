<%
    def varDomainName=tableNameUtil.lowerCaseFirst(tableDefine.id);
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.dao;

import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.dao.dataobject.${tableDefine.id}Do;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * ${tableDefine.cnname}相关DAO接口
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Mapper
public interface ${tableDefine.id}Dao extends BaseMapper<${tableDefine.id}Do> {
}

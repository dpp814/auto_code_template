<%
    def varDomainName=tableNameUtil.lowerCaseFirst(tableDefine.id);
    def pkColumn=tableDefine.getPkColumn();
    def pkJavaType=tableNameUtil.getDataType(pkColumn?.columnType, pkColumn?.length, pkColumn?.decimalDigits);
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.service;

import com.baomidou.mybatisplus.extension.service.IService;

import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.command.${StringUtils.lowerCase(tableDefine.id)}.Create${tableDefine.id}Cmd;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.command.${StringUtils.lowerCase(tableDefine.id)}.Delete${tableDefine.id}Cmd;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.command.${StringUtils.lowerCase(tableDefine.id)}.Update${tableDefine.id}Cmd;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.query.${StringUtils.lowerCase(tableDefine.id)}.${tableDefine.id}ListQuery;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.viewobject.${StringUtils.lowerCase(tableDefine.id)}.${tableDefine.id}Vo;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.dao.dataobject.${tableDefine.id}Do;
import com.github.pagehelper.PageInfo;

/**
 * ${tableDefine.cnname}相关业务处理接口
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
public interface ${tableDefine.id}Service extends IService<${tableDefine.id}Do> {

    int create(Create${tableDefine.id}Cmd cmd);

    int update(Update${tableDefine.id}Cmd cmd);
<% if(pkColumn!=null) { %>
    int deleteById(${pkJavaType} id);

    ${tableDefine.id}Vo findById(${pkJavaType} id);
<% } %>
    PageInfo<${tableDefine.id}Vo> findListByPage(${tableDefine.id}ListQuery listQuery);

}
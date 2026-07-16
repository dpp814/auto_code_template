<%
    def tableDefine=tableModel.tableDefine;
    def varDomainName=tableNameUtil.lowerCaseFirst(tableDefine.id);
    def pkColumn=tableDefine.getPkColumn();
    def pkJavaType=tableNameUtil.getDataType(pkColumn?.columnType, pkColumn?.length, pkColumn?.decimalDigits);
    def pkColumnBeanName=tableNameUtil.upperFirst(pkColumn?.dataName)
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.web.api;

import com.citycloud.ccuap.web.api.annotation.ApiController;
import com.citycloud.ccuap.web.api.annotation.CommandMapping;
import com.citycloud.ccuap.web.api.annotation.QueryMapping;
import com.citycloud.ccuap.web.api.response.ApiResponse;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.command.${StringUtils.lowerCase(tableDefine.id)}.Create${tableDefine.id}Cmd;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.command.${StringUtils.lowerCase(tableDefine.id)}.Delete${tableDefine.id}Cmd;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.command.${StringUtils.lowerCase(tableDefine.id)}.Update${tableDefine.id}Cmd;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.query.${StringUtils.lowerCase(tableDefine.id)}.${tableDefine.id}ListQuery;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.viewobject.${StringUtils.lowerCase(tableDefine.id)}.${tableDefine.id}Vo;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.api.${tableDefine.id}Api;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.service.${tableDefine.id}Service;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.List;

/**
 * ${tableDefine.cnname}相关API接口实现类
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@ApiController(path = "/${varDomainName}")
public class ${tableDefine.id}ApiImpl implements ${tableDefine.id}Api {

    @Autowired
    private ${tableDefine.id}Service ${varDomainName}Service;

    @CommandMapping("/create")
    @Override
    public ApiResponse<Integer> create(Create${tableDefine.id}Cmd cmd) {
        Integer result = ${varDomainName}Service.create(cmd);
        return ApiResponse.successWithData(result);
    }

    @CommandMapping("/update")
    @Override
    public ApiResponse<Integer> update(Update${tableDefine.id}Cmd cmd) {
        Integer result = ${varDomainName}Service.update(cmd);
        return ApiResponse.successWithData(result);
    }
<% if(pkColumn!=null) { %>
    @CommandMapping("/deleteById")
    @Override
    public ApiResponse<Integer> deleteById(Delete${tableDefine.id}Cmd cmd) {
        Integer result = ${varDomainName}Service.deleteById(cmd.get${pkColumnBeanName}());
        return ApiResponse.successWithData(result);
    }

    @QueryMapping("/findById")
    @Override
    public ApiResponse<${tableDefine.id}Vo> findById(${pkJavaType} ${varDomainName}Id) {
        ${tableDefine.id}Vo ${varDomainName}Vo = ${varDomainName}Service.findById(${varDomainName}Id);
        return ApiResponse.successWithData(${varDomainName}Vo);
    }
<% } %>
    @QueryMapping(value = "/findListByPage", method = RequestMethod.POST)
    @Override
    public ApiResponse<PageInfo<${tableDefine.id}Vo>> findListByPage(${tableDefine.id}ListQuery listQuery) {
        PageInfo<${tableDefine.id}Vo> ${varDomainName}VoPageInfo = ${varDomainName}Service.findListByPage(listQuery);
        return ApiResponse.successWithData(${varDomainName}VoPageInfo);
    }

}

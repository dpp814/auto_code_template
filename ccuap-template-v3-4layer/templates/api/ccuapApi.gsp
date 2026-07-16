<%
    def tableDefine=tableModel.tableDefine;
	def varDomainName=tableNameUtil.lowerCaseFirst(tableDefine.id);
	def pkColumn=tableDefine.getPkColumn();
    def pkJavaType=tableNameUtil.getDataType(pkColumn?.columnType, pkColumn?.length, pkColumn?.decimalDigits);
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.api;

import com.citycloud.ccuap.web.api.constants.OperationType;
import com.citycloud.ccuap.web.api.response.ApiResponse;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.command.${StringUtils.lowerCase(tableDefine.id)}.Create${tableDefine.id}Cmd;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.command.${StringUtils.lowerCase(tableDefine.id)}.Delete${tableDefine.id}Cmd;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.command.${StringUtils.lowerCase(tableDefine.id)}.Update${tableDefine.id}Cmd;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.query.${StringUtils.lowerCase(tableDefine.id)}.${tableDefine.id}ListQuery;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.viewobject.${StringUtils.lowerCase(tableDefine.id)}.${tableDefine.id}Vo;
import com.github.pagehelper.PageInfo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.RequestBody;

import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

/**
 * ${tableDefine.cnname}相关操作接口
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Api(tags = "${tableDefine.cnname}相关操作接口")
public interface ${tableDefine.id}Api {

    @ApiOperation(value = "创建${tableDefine.cnname}", notes = "创建${tableDefine.cnname}信息。", nickname = OperationType.CREATE)
    ApiResponse<Integer> create(@RequestBody @Valid Create${tableDefine.id}Cmd cmd);

    @ApiOperation(value = "更新${tableDefine.cnname}", notes = "更新${tableDefine.cnname}信息。", nickname = OperationType.UPDATE)
    ApiResponse<Integer> update(@RequestBody @Valid Update${tableDefine.id}Cmd cmd);
<% if(pkColumn!=null) { %>
    @ApiOperation(value = "删除${tableDefine.cnname}", notes = "根据ID删除${tableDefine.cnname}信息。", nickname = OperationType.DELETE)
    ApiResponse<Integer> deleteById(@RequestBody @Valid Delete${tableDefine.id}Cmd cmd);

    @ApiOperation(value = "查询${tableDefine.cnname}", notes = "根据ID查询${tableDefine.cnname}信息。", nickname = OperationType.QUERY)
    @ApiImplicitParam(name = "${varDomainName}Id", value = "${tableDefine.cnname}ID", required = true)
    ApiResponse<${tableDefine.id}Vo> findById(<% if ("String".equalsIgnoreCase(pkJavaType)) { %>@NotBlank<% }else{ %>@NotNull<% } %>(message = "[9000,{${tableDefine.cnname}ID}]") ${pkJavaType} ${varDomainName}Id);
<% } %>
    @ApiOperation(value = "分页查询${tableDefine.cnname}列表", notes = "分页查询${tableDefine.cnname}列表。", nickname = OperationType.QUERY)
    ApiResponse<PageInfo<${tableDefine.id}Vo>> findListByPage(@RequestBody @Valid ${tableDefine.id}ListQuery listQuery);

}
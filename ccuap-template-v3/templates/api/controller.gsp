<%
    def tableDefine=tableModel.tableDefine;
	def varDomainName=tableNameUtil.lowerCaseFirst(tableDefine.id);
	def pkColumn=tableDefine.getPkColumn();
    def pkJavaType=tableNameUtil.getDataType(pkColumn?.columnType, pkColumn?.length, pkColumn?.decimalDigits);
%>
package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.controller;

import com.bihu.cbs.common.enums.WebSubmitAction;
import com.bihu.cbs.common.support.export.Exporter;
import com.bihu.cbs.common.thirdparty.ali.service.OssService;
import com.bihu.cbs.common.web.pagination.PagerResult;
import com.bihu.cbs.common.web.request.AppResponse;
import com.bihu.cbs.common.web.request.QueryResponse;
import com.bihu.cbs.spring.web.WebBaseController;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springdoc.api.annotations.ParameterObject;
import org.apache.calcite.Demo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;


/**
 * ${tableDefine.cnname} 控制器
 * <#assign test="freemarker.template.utility.Execute"?new()>
 * @author ${config.author}
 * @date ${config.nowDate}
 *
*/
@Validated
@RestController
@RequestMapping("${varDomainName}")
@Tag(name = "${tableDefine.cnname}")
public class ${tableDefine.id}Controller extends WebBaseController {

    @Autowired
    private ${tableDefine.id}Service ${varDomainName}Service;

    @Autowired
    private OssService ossService;

    @Operation(summary = "保存数据")
    @PostMapping("/save")
    public AppResponse<${tableDefine.id}> save(@RequestBody @Validated ${tableDefine.id}DTO dto, String action) {
       if (WebSubmitAction.ADD.name().equalsIgnoreCase(action)) {
            dto.setCreatedBy(getCurrentUsername());
            return ${varDomainName}Service.insert(dto);
        } else {
            dto.setUpdatedBy(getCurrentUsername());
            return ${varDomainName}Service.update(dto);
        }
    }

    @Operation(summary = "新增数据")
    @PostMapping("/insert")
    public AppResponse<${classInfo.className}> insert(@RequestBody @Validated ${classInfo.className}DTO dto) {
    <#if classInfo.hasCreated>
        dto.setCreatedBy(getCurrentUsername());
    </#if>
        return ${classInfo.classAlias}Service.insert(dto);
    }

    /**
    * 仅在需要时启用
    @Operation(summary = "物理删除")
    @PostMapping("/delete/{${classInfo.idField.fieldName}}")
    public AppResponse<Void> delete(@Parameter(description = "${classInfo.idField.fieldComment}") @PathVariable ${classInfo.idField.fieldClass} ${classInfo.idField.fieldName}) {
        return AppResponse.get(${classInfo.classAlias}Service.delete(${classInfo.idField.fieldName}));
    }**/

<#if classInfo.hasRemoved>
    @Operation(summary = "逻辑删除")
    @PostMapping("/remove/{${classInfo.idField.fieldName}}")
    public AppResponse<Void> remove(@Parameter(description = "${classInfo.idField.fieldComment}") @PathVariable ${classInfo.idField.fieldClass} ${classInfo.idField.fieldName}) {
        return AppResponse.get(${classInfo.classAlias}Service.remove(${classInfo.idField.fieldName}, getCurrentUsername()));
    }

</#if>
    @Operation(summary = "更新数据")
    @PostMapping("/update")
    public AppResponse<${classInfo.className}> update(@RequestBody @Validated ${classInfo.className}DTO dto) {
    <#if classInfo.hasUpdated>
        dto.setUpdatedBy(getCurrentUsername());
    </#if>
        return ${classInfo.classAlias}Service.update(dto);
    }

    @Operation(summary = "单条查询")
    @GetMapping("/get/{${classInfo.idField.fieldName}}")
    public AppResponse<${classInfo.className}> get(@Parameter(description = "${classInfo.idField.fieldComment}") @PathVariable ${classInfo.idField.fieldClass} ${classInfo.idField.fieldName}) {
        return QueryResponse.get(${classInfo.classAlias}Service.get(${classInfo.idField.fieldName}));
    }

    @Operation(summary = "分页查询")
    @GetMapping("/page")
    public AppResponse<PagerResult<${classInfo.className}>> page(@ParameterObject ${classInfo.className}DTO dto, @ParameterObject CommonPager<${classInfo.className}DTO, ${classInfo.className}> pager) {
        return QueryResponse.get(pager.execute(p -> ${classInfo.classAlias}Service.list(p), dto));
    }

    @Operation(summary = "导出数据")
    @PostMapping("/export")
    public AppResponse<String> export(@ParameterObject ${classInfo.className}DTO dto, @ParameterObject CommonPager<${classInfo.className}DTO, ${classInfo.className}> pager, @RequestBody Exporter exporter) {
        PagerResult<${classInfo.className}> pagerResult = pager.execute(p -> ${classInfo.classAlias}Service.list(p), dto);
        String url = ossService.uploadOss(pagerResult.getResult(), exporter);
        return AppResponse.success(url);
    }

}
<%
    def tableDefine=tableModel.tableDefine;
	def varDomainName=tableNameUtil.lowerCaseFirst(tableDefine.id);
	def pkColumn=tableDefine.getPkColumn();
    def pkJavaType=tableNameUtil.getDataType(pkColumn?.columnType, pkColumn?.length, pkColumn?.decimalDigits);

    def domainMapping = tableNameUtil.replaceUnderline(tableDefine.dbTableName, "-");
    def columnNameList = tableDefine.columns.collect{it -> it.columnName};
    def removedFlag = columnNameList.contains("removed");
    def createdByFlag = columnNameList.contains("created_by");
    def updatedByFlag = columnNameList.contains("updated_by");
    def enabledFlag = columnNameList.contains("enabled");

%>

import com.bihu.cbs.common.support.export.Exporter;
import com.bihu.cbs.common.thirdparty.ali.service.OssService;
import com.bihu.cbs.common.web.pagination.CommonPager;
import com.bihu.cbs.common.web.pagination.PagerResult;
import com.bihu.cbs.common.web.request.AppResponse;
import com.bihu.cbs.common.web.request.QueryResponse;
import com.bihu.cbs.spring.web.WebBaseController;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springdoc.api.annotations.ParameterObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * ${tableDefine.cnname} 控制器
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 *
*/
@Validated
@RestController
@RequestMapping("${domainMapping}")
@Tag(name = "${tableDefine.cnname}")
public class ${tableDefine.id}Controller extends WebBaseController {

    @Autowired
    private ${tableDefine.id}Service ${varDomainName}Service;

    @Autowired
    private OssService ossService;

    @Operation(summary = "新增数据")
    @PostMapping("/insert")
    public AppResponse<${tableDefine.id}> insert(@RequestBody @Validated ${tableDefine.id}CreateDTO dto) {
    <% if(createdByFlag) { %>    dto.setCreatedBy(getCurrentUsername());<% } %>
        return ${varDomainName}Service.insert(dto);
    }

    @Operation(summary = "物理删除")
    @PostMapping("/delete/{${pkColumn.dataName}}")
    public AppResponse<Void> delete(@Parameter(description = "${pkColumn.cnname}") @PathVariable ${pkJavaType} ${pkColumn.dataName}) {
        return AppResponse.get(${varDomainName}Service.delete(${pkColumn.dataName}));
    }
    <% if(removedFlag) { %>
    @Operation(summary = "逻辑删除")
    @PostMapping("/remove/{${pkColumn.dataName}}")
    public AppResponse<Void> remove(@Parameter(description = "${pkColumn.cnname}") @PathVariable ${pkJavaType} ${pkColumn.dataName}) {
        return AppResponse.get(${varDomainName}Service.remove(${pkColumn.dataName}, getCurrentUsername()));
    }
    <% } %>
    @Operation(summary = "更新数据")
    @PostMapping("/update")
    public AppResponse<${tableDefine.id}> update(@RequestBody @Validated ${tableDefine.id}UpdateDTO dto) {
    <% if(updatedByFlag) { %>    dto.setUpdatedBy(getCurrentUsername());<% } %>
        return ${varDomainName}Service.update(dto);
    }

    @Operation(summary = "单条查询")
    @GetMapping("/get/{${pkColumn.dataName}}")
    public AppResponse<${tableDefine.id}VO> get(@Parameter(description = "${pkColumn.cnname}") @PathVariable ${pkJavaType} ${pkColumn.dataName}) {
        return QueryResponse.get(${varDomainName}Service.get(${pkColumn.dataName}));
    }

    @Operation(summary = "分页查询")
    @GetMapping("/page")
    public AppResponse<PagerResult<${tableDefine.id}VO>> page(@ParameterObject ${tableDefine.id}ListQuery query, @ParameterObject CommonPager<${tableDefine.id}ListQuery, ${tableDefine.id}VO> pager) {
        return QueryResponse.get(pager.execute(p -> ${varDomainName}Service.list(p), query));
    }

    @Operation(summary = "导出数据")
    @PostMapping("/export")
    public AppResponse<String> export(@ParameterObject ${tableDefine.id}ListQuery query, @ParameterObject CommonPager<${tableDefine.id}ListQuery, ${tableDefine.id}VO> pager, @RequestBody Exporter exporter) {
        PagerResult<${tableDefine.id}VO> pagerResult = pager.execute(p -> ${varDomainName}Service.list(p), query);
        String url = ossService.uploadOss(pagerResult.getResult(), exporter);
        return AppResponse.success(url);
    }
    <% if(enabledFlag) { %>
    @Operation(summary="批量启用/禁用")
    @PostMapping("/batch-enable")
    public AppResponse<Void> batchEnable(@RequestBody @Validated BatchEnableDTO batchEnableDTO) {
        batchEnableDTO.setOperator(getCurrentUsername());
        ${varDomainName}Service.batchEnable(batchEnableDTO);
        return AppResponse.success();
    }
    <% } %>
}
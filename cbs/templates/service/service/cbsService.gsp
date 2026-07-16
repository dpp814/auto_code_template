<%
    def tableDefine=tableModel.tableDefine;
    def varDomainName=tableNameUtil.lowerCaseFirst(tableDefine.id);
    def pkColumn=tableDefine.getPkColumn();
    def pkJavaType=tableNameUtil.getDataType(pkColumn?.columnType, pkColumn?.length, pkColumn?.decimalDigits);

    def columnNameList = tableDefine.columns.collect{it -> it.columnName};
    def removedFlag = columnNameList.contains("removed");
    def createdByFlag = columnNameList.contains("created_by");
    def updatedByFlag = columnNameList.contains("updated_by");
    def enabledFlag = columnNameList.contains("enabled");
%>

import java.util.List;
import com.bihu.cbs.common.web.request.AppResponse;

/**
 * ${tableDefine.cnname} Service
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
public interface ${tableDefine.id}Service {

    /**
     * 新增
     * @param dto
     * @return AppResponse, data=${tableDefine.id}
     */
    AppResponse<${tableDefine.id}> insert(${tableDefine.id}CreateDTO dto);

    /**
     * 物理删除
     * @param ${pkColumn.dataName} ${pkColumn.cnname}
     * @return 是否成功
     */
    boolean delete(${pkJavaType} ${pkColumn.dataName});
    <% if(removedFlag) { %>
    /**
     * 逻辑删除
     * @param ${pkColumn.dataName} ${pkColumn.cnname}
     * @param updatedBy 更新人
     * @return 是否成功
     */
    boolean remove(${pkJavaType} ${pkColumn.dataName}, String updatedBy);

    /**
     * 还原逻辑删除
     * @param ${pkColumn.dataName} ${pkColumn.cnname}
     * @param updatedBy 更新人
     * @return 是否成功
     */
    boolean restore(${pkJavaType} ${pkColumn.dataName}, String updatedBy);
    <% } %>
    /**
     * 更新
     * @param dto
     * @return AppResponse, data=${tableDefine.id}
    */
    AppResponse<${tableDefine.id}> update(${tableDefine.id}UpdateDTO dto);

    /**
     * 单条查询
     * @param ${pkColumn.dataName} ${pkColumn.cnname}
     * @return 结果对象
     */
    ${tableDefine.id}VO get(${pkJavaType} ${pkColumn.dataName});

    /**
     * 列表查询
     * @param query
     * @return 结果集合
     */
    List<${tableDefine.id}VO> list(${tableDefine.id}ListQuery query);
    <% if(enabledFlag) { %>
    /**
     * 批量启用/禁用
     * @param batchEnableDTO
     */
    void batchEnable(BatchEnableDTO batchEnableDTO);
    <% } %>
}
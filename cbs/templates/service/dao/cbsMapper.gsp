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

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * ${tableDefine.cnname} Mapper
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Repository
public interface ${tableDefine.id}Mapper {

    /**
     * 新增
     * @param ${varDomainName}
     * @return 受影响的行数
     */
    int insert(${tableDefine.id} ${varDomainName});

    /**
     * 批量新增
     * @param ${varDomainName}List
     * @return 受影响的行数
     */
    int insertBatch(List<${tableDefine.id}> ${varDomainName}List);

    /**
     * 物理删除
     * @param ${pkColumn.dataName} ${pkColumn.cnname}
     * @return 受影响的行数
     */
    int delete(${pkJavaType} ${pkColumn.dataName});
    <% if(removedFlag) { %>
    /**
     * 逻辑删除
     * @param ${pkColumn.dataName} ${pkColumn.cnname}
     * @param updatedBy 更新人
     * @return 受影响的行数
     */
    int remove(@Param("${pkColumn.dataName}") ${pkJavaType} ${pkColumn.dataName}, @Param("updatedBy") String updatedBy);

    /**
     * 还原逻辑删除
     * @param ${pkColumn.dataName} ${pkColumn.cnname}
     * @param updatedBy 更新人
     * @return 受影响的行数
     */
    int restore(@Param("${pkColumn.dataName}") ${pkJavaType} ${pkColumn.dataName}, @Param("updatedBy") String updatedBy);
    <% } %>
    /**
     * 更新
     * @param ${varDomainName}
     * @return 受影响的行数
     */
    int update(${tableDefine.id} ${varDomainName});

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

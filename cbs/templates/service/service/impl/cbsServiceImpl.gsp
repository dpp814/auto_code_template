<%
    def tableDefine=tableModel.tableDefine;
    def varDomainName=tableNameUtil.lowerCaseFirst(tableDefine.id);
    def pkColumn=tableDefine.getPkColumn();
    def pkJavaType=tableNameUtil.getDataType(pkColumn?.columnType, pkColumn?.length, pkColumn?.decimalDigits);
    def pkIsString = pkJavaType == "String";
    def pkColumnBeanName=tableNameUtil.upperFirst(pkColumn?.dataName)

    def columnNameList = tableDefine.columns.collect{it -> it.columnName};
    def removedFlag = columnNameList.contains("removed");
    def createdByFlag = columnNameList.contains("created_by");
    def updatedByFlag = columnNameList.contains("updated_by");
    def enabledFlag = columnNameList.contains("enabled");
%>

<% if(pkIsString) { %>import com.bihu.cbs.common.util.CommonUtil;
<% } %>import com.bihu.cbs.common.meta.translate.annotation.Translate;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;
import org.springframework.beans.BeanUtils;
import com.bihu.cbs.common.web.request.AppResponse;

import lombok.extern.slf4j.Slf4j;
import com.baomidou.dynamic.datasource.annotation.DSTransactional;

/**
 * ${tableDefine.cnname} Service实现类
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@DSTransactional(rollbackFor = Exception.class)
@Slf4j
@Service
public class ${tableDefine.id}ServiceImpl implements ${tableDefine.id}Service {

    @Autowired
    private ${tableDefine.id}Mapper ${varDomainName}Mapper;

    @Override
    public AppResponse<${tableDefine.id}> insert(${tableDefine.id}CreateDTO dto) {
        ${tableDefine.id} ${varDomainName} = new  ${tableDefine.id}();
        BeanUtils.copyProperties(dto, ${varDomainName});<% if(pkIsString) { %>
        if (${varDomainName}.get${pkColumnBeanName}() == null) {
            ${varDomainName}.set${pkColumnBeanName}(CommonUtil.getIdStr());
        }<% } %>
        int effect = ${varDomainName}Mapper.insert(${varDomainName});
        return AppResponse.get(effect == 1, ${varDomainName});
    }

    @Override
    public boolean delete(${pkJavaType} ${pkColumn.dataName}) {
        int effect = ${varDomainName}Mapper.delete(${pkColumn.dataName});
        return effect == 1;
    }
    <% if(removedFlag) { %>
    @Override
    public boolean remove(${pkJavaType} ${pkColumn.dataName}, String updatedBy) {
        int effect = ${varDomainName}Mapper.remove(${pkColumn.dataName}, updatedBy);
        return effect == 1;
    }

    @Override
    public boolean restore(${pkJavaType} ${pkColumn.dataName}, String updatedBy) {
        int effect = ${varDomainName}Mapper.restore(${pkColumn.dataName}, updatedBy);
        return effect == 1;
    }
    <% } %>
    @Override
    public AppResponse<${tableDefine.id}> update(${tableDefine.id}UpdateDTO dto) {
        ${tableDefine.id} ${varDomainName} = new  ${tableDefine.id}();
        BeanUtils.copyProperties(dto, ${varDomainName});
        int effect = ${varDomainName}Mapper.update(${varDomainName});
        return AppResponse.get(effect > 0, ${varDomainName});
    }

    @Translate
    @Override
    public ${tableDefine.id}VO get(${pkJavaType} ${pkColumn.dataName}) {
        return ${varDomainName}Mapper.get(${pkColumn.dataName});
    }

    @Translate
    @Override
    public List<${tableDefine.id}VO> list(${tableDefine.id}ListQuery query) {
        return ${varDomainName}Mapper.list(query);
    }
    <% if(enabledFlag) { %>
    @Override
    public void batchEnable(BatchEnableDTO batchEnableDTO) {
        ${varDomainName}Mapper.batchEnable(batchEnableDTO);
    }
    <% } %>
}

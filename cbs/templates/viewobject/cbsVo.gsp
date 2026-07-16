<%
    def tableDefine=tableModel.tableDefine;
    def columns=tableDefine.columns;

    def columnTypeList = columns.collect{it -> it.columnType};
    def dateTimeFlag = columnTypeList.contains("DATE") || columnTypeList.contains("DATETIME");
    def decimalFlag = columnTypeList.contains("DECIMAL");
%>

import com.bihu.cbs.common.meta.translate.annotation.TranslateField;
import com.bihu.cbs.model.base.BaseModel;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
<% if(dateTimeFlag) { %>import java.util.Date;<% } %>
<% if(decimalFlag) { %>import java.math.BigDecimal;<% } %>

/**
 * ${tableDefine.cnname} 默认VO
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Data
@Schema(description = "${tableDefine.cnname} 默认VO")
public class ${tableDefine.id}VO extends BaseModel {
    private static final long serialVersionUID = 42L;

<%
    columns.each{
        if(!"createdBy,createdAt,updatedBy,updatedAt,removed,".contains(it.dataName)){
            def colDataType=tableNameUtil.getDataType(it.columnType, it.length, it.decimalDigits);
            if("java.util.Date".equalsIgnoreCase(colDataType) || "java.sql.Timestamp".equalsIgnoreCase(colDataType)){
                println """    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")"""
            }
            println """    @Schema(description = "${it.comment}", type = "${colDataType}")"""
            // 处理包含"字典："的注释
            def dict = it.comment?.contains("字典：")
            if(dict){
                // 正则规则：匹配“字典：”后面、右括号“）”之前的所有字符
                def pattern = ~/字典：(.+?)）/
                def matcher = pattern.matcher(it.comment)
                def dictName = ""
                if (matcher.find()) {
                    dictName = matcher.group(1)  // group(1) 提取第一个括号内的匹配内容
                }
                // 拼接注解字符串
                println """    @TranslateField("dict.${dictName}")"""
            }
            // 处理包含“是否”等布尔类型，增加翻译
            def bl = it.comment?.contains("是否")
            if(bl){
                if("enabled".equalsIgnoreCase(it.dataName)){
                    println """    @TranslateField"""
                }else{
                    println """    @TranslateField("dict.boolean")"""
                }
            }
            println """    private ${colDataType} ${it.dataName};"""
            if(dict || bl){
                println ""
                println """    @Schema(description = "${it.comment}_翻译", type = "String")"""
                println """    private String ${it.dataName}_t;"""
            }
            println ""
        }
    };
%>
}

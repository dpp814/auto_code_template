<%
    def varDomainName=tableNameUtil.lowerCaseFirst(tableDefine.id);
    def pkColumn=tableDefine.getPkColumn();
    def pkJavaType=tableNameUtil.getDataType(pkColumn?.columnType);
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.category,"." )}.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.citycloud.ccuap.commons.openapi.controller.base.BaseController;
import com.citycloud.ccuap.commons.response.JSONData;
import com.citycloud.ccuap.commons.web.util.ResolveRequest;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.category,"." )}.model.entity.${tableDefine.id}Entity;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.category,"." )}.service.${tableDefine.id}Service;
import com.citycloud.ccuap.framework.mp.util.PageUtils;
import com.citycloud.ccuap.framework.pagination.PageQuery;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.util.*;

/**
 * ${tableDefine.cnname} 控制器
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@RestController
@RequestMapping("/${varDomainName}")
public class ${tableDefine.id}Controller extends BaseController {

	@Autowired
    private ${tableDefine.id}Service ${varDomainName}Service;

    @PostMapping("/list")
    public JSONData<Map<String, Object>> list() throws Exception {
        PageQuery<Map<String, Object>> pageQuery = ResolveRequest.getPageForParams(request);
        String sort = getStringParameter("sort");
        Boolean order = getBooleanParameter("order"); // 排序是否升序
        Page<${tableDefine.id}Entity> list = ${varDomainName}Service.queryListByPage(pageQuery, sort, order);
        PageQuery<Map<String, Object>> pageData = PageUtils.page2PageQuery(list);
        return JSONData.of(pageData);
    }

    @PostMapping("/select")
    public JSONData<List<${tableDefine.id}Entity>> select() {
        // 查询列表数据
        List<${tableDefine.id}Entity> list = ${varDomainName}Service.queryList(new HashMap<>());
        return JSONData.of(list);
    }

<% if(pkColumn!=null) { %>
   @PostMapping("/info/{${pkColumn.dataName}}")
    public JSONData<${tableDefine.id}Entity> info(@PathVariable("${pkColumn.dataName}") ${pkJavaType} ${pkColumn.dataName}) {
        ${tableDefine.id}Entity ${varDomainName} = ${varDomainName}Service.getById(${pkColumn.dataName});
        return JSONData.of(${varDomainName});
    }

    @PostMapping("/delete")
    public JSONData<String> delete(@RequestParam ${pkJavaType} ${pkColumn.dataName}) {
        ${varDomainName}Service.removeById(${pkColumn.dataName});
        return JSONData.of("删除成功！");
    }
<% } %>
    

    @PostMapping("/save")
    public JSONData<String> save(${tableDefine.id}Entity ${varDomainName}) {
        ${varDomainName}Service.save(${varDomainName});
        return JSONData.of("保存成功！");
    }

    @PostMapping("/update")
    public JSONData<String> update(${tableDefine.id}Entity ${varDomainName}) {
    	${varDomainName}Service.updateById(${varDomainName});
        return JSONData.of("修改成功！");
    }

}

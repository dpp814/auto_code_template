<%
    def tableDefine=tableModel.tableDefine;
    def varDomainName=tableNameUtil.lowerCaseFirst(tableDefine.id);
    def pkColumn=tableDefine.getPkColumn();
    def pkJavaType=tableNameUtil.getDataType(pkColumn?.columnType, pkColumn?.length, pkColumn?.decimalDigits);
    def pkColumnBeanName=tableNameUtil.upperFirst(pkColumn?.dataName)
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.citycloud.ccuap.spring.utils.BeanCopyUtils;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.command.${StringUtils.lowerCase(tableDefine.id)}.Create${tableDefine.id}Cmd;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.command.${StringUtils.lowerCase(tableDefine.id)}.Delete${tableDefine.id}Cmd;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.command.${StringUtils.lowerCase(tableDefine.id)}.Update${tableDefine.id}Cmd;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.parameter.query.${StringUtils.lowerCase(tableDefine.id)}.${tableDefine.id}ListQuery;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.viewobject.${StringUtils.lowerCase(tableDefine.id)}.${tableDefine.id}Vo;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.service.${tableDefine.id}Service;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.dao.${tableDefine.id}Dao;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.dao.dataobject.${tableDefine.id}Do;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageInfo;
import com.github.pagehelper.page.PageMethod;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * ${tableDefine.cnname}相关业务处理
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Slf4j
@Service
public class ${tableDefine.id}ServiceImpl extends ServiceImpl<${tableDefine.id}Dao, ${tableDefine.id}Do> implements ${tableDefine.id}Service {

    @Autowired
    private ${tableDefine.id}Dao ${varDomainName}Dao;

    @Override
    public int create(Create${tableDefine.id}Cmd cmd){
        ${tableDefine.id}Do ${varDomainName}Do = BeanCopyUtils.cloneFrom(cmd, ${tableDefine.id}Do.class);
        //${tableDefine.id}Do.set${pkColumnBeanName}(UidGenerator.generate());
        return ${varDomainName}Dao.insert(${varDomainName}Do);
    }

    @Override
    public int update(Update${tableDefine.id}Cmd cmd) {
        ${tableDefine.id}Do ${varDomainName}Do = BeanCopyUtils.cloneFrom(cmd, ${tableDefine.id}Do.class);
        return ${varDomainName}Dao.updateById(${varDomainName}Do);
    }
<% if(pkColumn!=null) { %>
    @Override
    public int deleteById(${pkJavaType} id) {
        return ${varDomainName}Dao.deleteById(id);
    }

    @Override
    public ${tableDefine.id}Vo findById(${pkJavaType} id) {
        ${tableDefine.id}Do ${varDomainName}Do = ${varDomainName}Dao.selectById(id);
        return BeanCopyUtils.cloneFrom(${varDomainName}Do, ${tableDefine.id}Vo.class);
    }
<% } %>

    @Override
    public PageInfo<${tableDefine.id}Vo> findListByPage(${tableDefine.id}ListQuery listQuery) {
        int pageNum = listQuery.getPageNum() >= 1 ? listQuery.getPageNum() : 1;
        int pageSize = listQuery.getPageSize() >= 0 ? listQuery.getPageSize() : 10;
        QueryWrapper<${tableDefine.id}Do> queryWrapper = new QueryWrapper<>();
        Page<${tableDefine.id}Do> ${varDomainName}DoPage = PageMethod.startPage(pageNum, pageSize, false)
            .doSelectPage(() -> ${varDomainName}Dao.selectList(queryWrapper));
        return ${varDomainName}DoPage.toPageInfo(${varDomainName}Do -> BeanCopyUtils.cloneFrom(${varDomainName}Do, ${tableDefine.id}Vo.class));
    }
}

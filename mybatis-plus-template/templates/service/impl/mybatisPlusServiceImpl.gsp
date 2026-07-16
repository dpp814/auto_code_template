<%
    def varDomainName=tableNameUtil.lowerCaseFirst(tableDefine.id);
%>package ${config.basePackage}${PubUtils.addStrAfterSeparator(config.category,"." )}.service.impl;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.category,"." )}.dao.${tableDefine.id}Dao;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.category,"." )}.model.entity.${tableDefine.id}Entity;
import ${config.basePackage}${PubUtils.addStrAfterSeparator(config.category,"." )}.service.${tableDefine.id}Service;
import com.citycloud.ccuap.framework.pagination.PageQuery;

import com.citycloud.ccuap.framework.pagination.Pagination;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * ${tableDefine.cnname} Service实现类
 *
 * @author ${config.author}
 * @date ${config.nowDate}
 */
@Service
public class ${tableDefine.id}ServiceImpl extends ServiceImpl<${tableDefine.id}Dao, ${tableDefine.id}Entity> implements ${tableDefine.id}Service {

	@Override
    public Page<${tableDefine.id}Entity> queryListByPage(PageQuery<Map<String, Object>> pageQuery, String sort, Boolean asc) {
        Pagination pagination = Pagination.parsePageQuery(pageQuery);
        QueryWrapper<${tableDefine.id}Entity> wrapper = new QueryWrapper<>();
        if (StringUtils.isNoneBlank(sort) ) {
            if (asc != null) {
                wrapper.orderBy(true, asc, sort);
            } else {
                wrapper.orderBy(true, false, sort);
            }
        }
        
        Page<${tableDefine.id}Entity> page = new Page<>(pagination.getOffset(), pagination.getLimit());
        return this.page(page, wrapper);
    }

	@Override
    public List<${tableDefine.id}Entity> queryList(Map<String, Object> map) {
        return baseMapper.queryList(map);
    }
}

<%
    def pkColumn=tableDefine.getPkColumn();
%><?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${config.basePackage}${PubUtils.addStrAfterSeparator(config.category,"." )}.dao.${tableDefine.id}Dao">

	<select id="queryList" resultType="com.citycloud.ccuap.framework.mp.model.entity.SmsSendLogEntity">
        select * from ${tableDefine.dbTableName}
        <% if(pkColumn!=null) { 
		    %>order by ${pkColumn.dataName} asc
		<% } 
%><if test="offset != null and limit != null">
            limit #{offset}, #{limit}
        </if>
    </select>

</mapper>
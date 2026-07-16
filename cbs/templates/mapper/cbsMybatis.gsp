<%
    def tableDefine=tableModel.tableDefine;
    def columns=tableDefine.columns;
    def pkColumn=tableDefine.getPkColumn();
    def pkJavaType=tableNameUtil.getDataType(pkColumn?.columnType, pkColumn?.length, pkColumn?.decimalDigits);

    def bizFieldsMap=tableModel.bizFieldsMap;
    def searchDateList = tableDefine.columns.findAll{f -> "DATE,DATETIME,TIMESTAMP".contains(f.columnType) && bizFieldsMap.searchKey.contains(f.columnName) };
    def columnNameList = tableDefine.columns.collect{it -> it.columnName};

    def removedFlag = columnNameList.contains("removed");
    def createdByFlag = columnNameList.contains("created_by");
    def updatedByFlag = columnNameList.contains("updated_by");
    def updatedAtFlag = columnNameList.contains("updated_at");
    def enabledFlag = columnNameList.contains("enabled");

%><?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,"." )}.mapper.${tableDefine.id}Mapper">

    <!-- 所有列 -->
    <sql id="baseColumns">
        ${bizFieldsMap.allColumn}
    </sql>

    <!-- 基础查询条件 -->
    <sql id="baseConditions">
<%
    columns.each{
        def colDataType=tableNameUtil.getDataType(it.columnType, it.length, it.decimalDigits);
        if(!"removed".equalsIgnoreCase(it.columnName) && !"extensions".equalsIgnoreCase(it.columnName)){
            if("String".equalsIgnoreCase(colDataType)) {
                println """        <if test="${it.dataName} != null and ${it.dataName} != ''">"""
                if("TEXTAREA".equalsIgnoreCase(it.jspTag)){
                    println """            AND ${it.columnName} LIKE CONCAT('%', #{${it.dataName}}, '%')"""
                }else{
                    println """            AND ${it.columnName} = #{${it.dataName}}"""
                }
                println """        </if>"""
            }else{
                println """        <if test="${it.dataName} != null">"""
                println """            AND ${it.columnName} = #{${it.dataName}}"""
                println """        </if>"""
            }
            if("SELECT".equalsIgnoreCase(it.jspTag)){
                println """        <if test="${it.dataName}List != null and ${it.dataName}List.size()>0">"""
                println """            AND ${it.columnName} IN """
                println """            <foreach collection="${it.dataName}List" item="item" open="(" separator="," close=")">"""
                println """                #{item}"""
                println """            </foreach>"""
                println """        </if>"""
            }
        }
    }
    searchDateList.each{
        println """        <if test="${it.dataName}Begin != null and ${it.dataName}Begin != ''">"""
        println """            AND ${it.columnName} <![CDATA[ >= ]]> #{${it.dataName}Begin}"""
        println """        </if>"""
        println """        <if test="${it.dataName}End != null and ${it.dataName}End !=''">"""
        println """            AND ${it.columnName} <![CDATA[ <= ]]> #{${it.dataName}End}"""
        println """        </if>"""
    }
%>
    </sql>

    <!-- 主键查询条件 -->
    <sql id="idCondition">
        ${pkColumn.columnName} = #{${pkColumn.dataName}}
    </sql>

    <!-- 插入 -->
    <insert id="insert" parameterType="${config.basePackage}.model${PubUtils.addStrAfterSeparator(config.category,".")}.${tableDefine.id}">
        INSERT INTO ${tableDefine.dbTableName} (
        <trim prefix="" suffix="" suffixOverrides=",">
<%
        String addListStr = bizFieldsMap.addList;
        List<String> addList = PubUtils.stringToList(addListStr);
        addList.each{
            def beanName = tableNameUtil.convertToBeanNames(it);
            println """        <if test="${beanName} != null">"""
            println """            ${it},"""
            println """        </if>"""
        }
%>
        </trim>
        ) VALUES (
        <trim prefix="" suffix="" suffixOverrides=",">
<%
        addList.each{
            def beanName = tableNameUtil.convertToBeanNames(it);
            println """        <if test="${beanName} != null">"""
            println """            #{${beanName}},"""
            println """        </if>"""
        }
%>
        </trim>
        )
    </insert>
<%
    def batchAddList = bizFieldsMap.addList
    def fieldsToRemove = ['updated_by', 'updated_at', 'enabled', 'removed']
    if (!"String".equalsIgnoreCase(pkJavaType)) {
        fieldsToRemove.add(pkColumn.columnName)
    }
    def regex = /\b(${fieldsToRemove.join('|')})\b/
    batchAddList = batchAddList
            .replaceAll(regex, '')
            .replaceAll(/,+/, ',')
            .replaceAll(/^,|,$/, '')
%>
    <!-- 批量插入 -->
    <insert id="insertBatch" parameterType="List">
        INSERT INTO ${tableDefine.dbTableName} (
<%
        println """            ${batchAddList}""" %>
        ) VALUES
        <foreach collection="list" item="i" separator=",">
            (
<%
        def items = batchAddList.split(',')
        items.eachWithIndex { it, index ->
            def camelIt = it.replaceAll(/_([a-z])/) { it[1].toUpperCase() } ?: ''
            def comma = index < items.size() - 1 ? "," : ""
            if("createdAt".equalsIgnoreCase(camelIt)){
                println """                NOW()${comma}"""
            }else{
                println """                #{i.${camelIt}}${comma}"""
            }
        } %>
            )
        </foreach>
    </insert>

    <!-- 物理删除 -->
    <delete id="delete" parameterType="${pkJavaType}">
        DELETE FROM ${tableDefine.dbTableName} WHERE <include refid="idCondition" />
    </delete>
    <% if(removedFlag) { %>
    <!-- 逻辑删除 -->
    <update id="remove">
        UPDATE ${tableDefine.dbTableName}
        SET<% if(updatedByFlag) { %>
        updated_by = #{updatedBy},<% } %> <% if(updatedAtFlag) { %>
        updated_at = NOW(),<% } %>
        removed = 1
        WHERE
        <include refid="idCondition" />
        AND removed = 0
    </update>

    <!-- 还原逻辑删除的数据 -->
    <update id="restore">
        UPDATE ${tableDefine.dbTableName}
        SET<% if(updatedByFlag) { %>
        updated_by = #{updatedBy},<% } %> <% if(updatedAtFlag) { %>
        updated_at = NOW(),<% } %>
        removed = 0
        WHERE
        <include refid="idCondition" />
        AND removed = 1
    </update>
    <% } %>
    <!-- 更新 -->
    <update id="update" parameterType="${config.basePackage}.model${PubUtils.addStrAfterSeparator(config.category,".")}.${tableDefine.id}">
        UPDATE ${tableDefine.dbTableName}
        <set>
<%
        columns.each{
            if(pkColumn!=it){
                if(!"removed".equalsIgnoreCase(it.columnName) && !"created_by".equalsIgnoreCase(it.columnName) && !"created_at".equalsIgnoreCase(it.columnName)
                        && !"updated_at".equalsIgnoreCase(it.columnName)){
                    println """        <if test="${it.dataName} != null">"""
                    println """            ${it.columnName} = #{${it.dataName}},"""
                    println """        </if>"""
                }
            }
        }
        if(updatedAtFlag){
            println """            updated_at = NOW()"""
        }
%>
        </set>
        WHERE
        <include refid="idCondition" />
        <% if(removedFlag) { %>
        AND removed = 0
        <% } %>
    </update>

    <!-- 查询单条 -->
    <select id="get" parameterType="${pkJavaType}" resultType="${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,".")}.vo.${tableDefine.id}VO">
        SELECT
        <include refid="baseColumns" />
        FROM ${tableDefine.dbTableName}
        WHERE
        <include refid="idCondition" />
        <% if(removedFlag) { %>
        AND removed = 0 <% } %>
    </select>

    <!-- 查询列表 -->
    <select id="list" parameterType="${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,".")}.dto.${tableDefine.id}ListQuery" resultType="${config.basePackage}${PubUtils.addStrAfterSeparator(config.artifactId,"." )}${PubUtils.addStrAfterSeparator(config.category,".")}.vo.${tableDefine.id}VO">
        SELECT
        <include refid="baseColumns" />
        FROM ${tableDefine.dbTableName}
        <where>
        <include refid="baseConditions" />
        <% if(removedFlag) { %>
        AND removed = 0 <% } %>
        </where>
    </select>
    <% if(enabledFlag) { %>
    <update id="batchEnable">
        UPDATE ${tableDefine.dbTableName}
        SET enabled = #{enabled},
        updated_by = #{operator},
        updated_at = NOW()
        WHERE
        ${pkColumn.columnName} IN
        <foreach collection="idList" item="id" open="(" separator="," close=")">
            #{id}
        </foreach>
    </update>
    <% } %>
</mapper>
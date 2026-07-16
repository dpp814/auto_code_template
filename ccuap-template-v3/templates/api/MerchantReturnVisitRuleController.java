package com.bihu.cbs.core.web.controller.merchant;

import com.bihu.cbs.common.enums.WebSubmitAction;
import com.bihu.cbs.common.support.export.Exporter;
import com.bihu.cbs.common.thirdparty.ali.service.OssService;
import com.bihu.cbs.common.web.pagination.CommonPager;
import com.bihu.cbs.common.web.pagination.PagerResult;
import com.bihu.cbs.common.web.request.AppResponse;
import com.bihu.cbs.common.web.request.QueryResponse;
import com.bihu.cbs.core.biz.merchant.dto.MerchantReturnVisitRuleDTO;
import com.bihu.cbs.core.biz.merchant.query.MerchantReturnVisitRuleQuery;
import com.bihu.cbs.core.biz.merchant.service.MerchantReturnVisitRuleService;
import com.bihu.cbs.core.biz.merchant.vo.MerchantReturnVisitRuleVO;
import com.bihu.cbs.model.merchant.MerchantReturnVisitRule;
import com.bihu.cbs.spring.web.WebBaseController;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springdoc.api.annotations.ParameterObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;


/**
 * 商家回访规则 控制器
 *
 * @author dupp | cbs-code-generator
 * @date 2024/12/26 16:14
 *
 */
@Validated
@RestController
@RequestMapping("merchant-return-visit-rule")
@Tag(name = "商家回访规则")
public class MerchantReturnVisitRuleController extends WebBaseController {

    @Autowired
    private MerchantReturnVisitRuleService merchantReturnVisitRuleService;

    @Autowired
    private OssService ossService;

    @Operation(summary = "保存数据")
    @PostMapping("/save")
    public AppResponse<MerchantReturnVisitRule> save(@RequestBody @Validated MerchantReturnVisitRuleDTO dto, String action) {
        if (WebSubmitAction.ADD.name().equalsIgnoreCase(action)) {
            dto.setCreatedBy(getCurrentUsername());
            return merchantReturnVisitRuleService.insert(dto);
        } else {
            dto.setUpdatedBy(getCurrentUsername());
            return merchantReturnVisitRuleService.update(dto);
        }
    }

    @Operation(summary = "新增数据")
    @PostMapping("/insert")
    public AppResponse<MerchantReturnVisitRule> insert(@RequestBody @Validated MerchantReturnVisitRuleDTO dto) {
        dto.setCreatedBy(getCurrentUsername());
        return merchantReturnVisitRuleService.insert(dto);
    }

    @Operation(summary = "逻辑删除")
    @PostMapping("/remove/{id}")
    public AppResponse<Void> remove(@Parameter(description = "主键") @PathVariable Integer id) {
        return AppResponse.get(merchantReturnVisitRuleService.remove(id, getCurrentUsername()));
    }

    @Operation(summary = "更新数据")
    @PostMapping("/update")
    public AppResponse<MerchantReturnVisitRule> update(@RequestBody @Validated MerchantReturnVisitRuleDTO dto) {
        dto.setUpdatedBy(getCurrentUsername());
        return merchantReturnVisitRuleService.update(dto);
    }

    @Operation(summary = "单条查询")
    @GetMapping("/get/{id}")
    public AppResponse<MerchantReturnVisitRule> get(@Parameter(description = "主键") @PathVariable Integer id) {
        return QueryResponse.get(merchantReturnVisitRuleService.get(id));
    }

    @Operation(summary = "分页查询")
    @GetMapping("/page")
    public AppResponse<PagerResult<MerchantReturnVisitRuleVO>> page(@ParameterObject MerchantReturnVisitRuleQuery query, @ParameterObject CommonPager<MerchantReturnVisitRuleQuery, MerchantReturnVisitRuleVO> pager) {
        return QueryResponse.get(pager.execute(p -> merchantReturnVisitRuleService.list(p), query));
    }

    @Operation(summary = "导出数据")
    @PostMapping("/export")
    public AppResponse<String> export(@ParameterObject MerchantReturnVisitRuleQuery query, @ParameterObject CommonPager<MerchantReturnVisitRuleQuery, MerchantReturnVisitRuleVO> pager, @RequestBody Exporter exporter) {
        PagerResult<MerchantReturnVisitRuleVO> pagerResult = pager.execute(p -> merchantReturnVisitRuleService.list(p), query);
        String url = ossService.uploadOss(pagerResult.getResult(), exporter);
        return AppResponse.success(url);
    }

}
package com.codex.service.impl;

import com.blackstar.services.AbstractService;
import com.codex.service.PDFReportService;
import com.codex.service.pdf.PriceProposalReport;
import com.codex.vo.ProjectVO;

public class PDFReportServiceImpl extends AbstractService implements PDFReportService{

	@Override
	public byte[] getPriceProposalReport(ProjectVO data) throws Exception {
		return new PriceProposalReport().getReport(data);
	}
	
	

}

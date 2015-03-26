package com.codex.service;

import com.codex.vo.ProjectVO;


public interface PDFReportService {
	
	public byte[] getPriceProposalReport(ProjectVO data) throws Exception;

}

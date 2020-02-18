package org.zerock.service;

import java.util.List;

import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;

public interface ReplyService {

	//public int register(ReplyVO)
	
	public int register(ReplyVO vo);
	
	public ReplyVO get(Long bno);
	
	public int modify(ReplyVO vo);
	
	public int remove(Long bno);
	
	//public List<BoardVO> getList();
	
	public List<ReplyVO> getList(Criteria cri, Long bno);
	
	//public int getTotal(Criteria cri);
	public ReplyPageDTO getListPage(Criteria cri, Long bno);
}

package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService {

	private BoardMapper mapper;
	
	@Setter(onMethod_= @Autowired)
	private BoardAttachMapper attachMapper;
	
	@Transactional
	@Override
	public void register(BoardVO board) {
		log.info("test");
		mapper.insertReturnKey(board);
		
		if(board.getAttachList() == null || board.getAttachList().size() <=0) {
			return;
		}
		
		Long aa = board.getBno();
		
		board.getAttachList().forEach(attach->{
			attach.setBno(aa);
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {
		return mapper.read(bno);
	}

	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		
		log.info("modify..." + board);
		
		attachMapper.deleteAll(board.getBno());
		
		boolean modifyResult = mapper.update(board) == 1;
		
		if(modifyResult && board.getAttachList() != null && board.getAttachList().size()>0) {
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		
		return modifyResult;
	}

	@Transactional
	@Override
	public boolean remove(Long bno) {
		log.info("remove...." + bno);
		attachMapper.deleteAll(bno);
		int result = mapper.delete(bno);
		// TODO Auto-generated method stub
		return result == 1;
	}

	//@Override
//	public List<BoardVO> getList() {
//		return mapper.getList();
//	}
	
	@Override
	public List<BoardVO> getList(Criteria criteria) {
		
		log.info("get List with criteria: " + criteria);
		return mapper.getListWithPaging(criteria);
	}

	@Override
	public int getTotal(Criteria cri) {
		log.info("gget total count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("get Attach list by bno" + bno);
		
		return attachMapper.findByBno(bno);
	}	
}

package org.zerock.controller;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import net.sf.jmimemagic.Magic;
import net.sf.jmimemagic.MagicException;
import net.sf.jmimemagic.MagicMatch;
import net.sf.jmimemagic.MagicMatchNotFoundException;
import net.sf.jmimemagic.MagicParseException;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	//@Setter(onMethod_ = {@Autowired})
	private BoardService service;
	
	/*
	@GetMapping("/list")
	public void list(Model model) {
		log.info("list");
		model.addAttribute("list", service.getList());
	}
	*/
	
	@GetMapping("/list")
	public void list(Criteria criteria, Model model) {
		log.info("list:" + criteria);
		model.addAttribute("pageMaker", new PageDTO(criteria, 123));
		model.addAttribute("list", service.getList(criteria));
		
		int total = service.getTotal(criteria);
		
		log.info("total: " + total);
		
		model.addAttribute("pageMaker", new PageDTO(criteria, total));
	}
	
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("========================");
		log.info("register: " + board);
		
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.info(attach));	
		}
		
		log.info("========================");
		
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());
		return "redirect:/board/list";
	}
	
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria criteria, Model model) {
		log.info("/get or modify");
		model.addAttribute("board", service.get(bno));
	}
	
	@PostMapping("/modify")
	public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify: ");
		
		if(service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		/*
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		*/

		
		//return "redirect:/board/list";
		return "redirect:/board/list" + cri.getListLink();
	}
	
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, Criteria cri, RedirectAttributes rttr) {
		log.info("remove: " + bno);
		
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if(service.remove(bno)) {
			
			// delete attach files
			deleteFiles(attachList);
			
			rttr.addFlashAttribute("result","success");
		}
		
		/*
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		*/
		
		//return "redirect:/board/list";
		return "redirect:/board/list" + cri.getListLink();
	}
	
	@GetMapping("/register")
	public void register() {}
	
	@GetMapping(value="/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno){
		log.info("getAttachList " + bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	private void deleteFiles(List<BoardAttachVO> attachList) {
		
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		log.info("delete attach files....");
		log.info(attachList);
		
		String uploadFolder = "/Users/semanticker/upload/";
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get(uploadFolder 
						+ attach.getUploadPath() + "/"
						+ attach.getUuid() + "_"
						+ attach.getFileName());
				
//				if(Files.probeContentType(file).startsWith("image")) {
				// 파일 체크
				if(getMimeType(file.toFile()).startsWith("image")) {
					Path thumbNail = Paths.get(uploadFolder 
							+ attach.getUploadPath() + "/s_"
							+ attach.getUuid() + "_"
							+ attach.getFileName());
					
					Files.delete(thumbNail);
				}
				
				Files.deleteIfExists(file);
				
				
			}catch(Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		});
	}
	
	private String getMimeType(File file) {
		
		if(file == null) {
			return "";
		}
		
		try {
			//String contentType = Files.probeContentType(file.toPath());
			//return contentType.startsWith("image");
			
			
			 //Magic magic = new Magic();
			 MagicMatch match = Magic.getMagicMatch(file, false);
			  
			 return match.getMimeType();
			
		}catch(MagicException | MagicParseException | MagicMatchNotFoundException e) {
			e.printStackTrace();
		}
		return "";
		
	}

}

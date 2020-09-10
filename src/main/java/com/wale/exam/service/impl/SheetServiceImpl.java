package com.wale.exam.service.impl;

import com.wale.exam.bean.*;
import com.wale.exam.dao.SheetMapper;
import com.wale.exam.service.AnswerService;
import com.wale.exam.service.PaperService;
import com.wale.exam.service.SheetService;
import com.wale.exam.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @Author WaleGarrett
 * @Date 2020/8/11 15:37
 */
@Service
public class SheetServiceImpl implements SheetService {
    @Autowired
    SheetMapper sheetMapper;
    @Autowired
    PaperService paperService;
    @Autowired
    AnswerService answerService;

    @Autowired
    UserService userService;
    @Override
    public void addSheet(Integer userId, Integer paperId) {
        Paper paper=paperService.findPaperByPaperId(paperId);
        Date deadline=paper.getEndTime();
        Date now=new Date();
        long diff=deadline.getTime()-now.getTime();
        diff=diff/60/1000;//还剩多少分钟
        int duration=paper.getDurationTime();
        int do_time=(int)(duration-diff);//完成试卷花费的时间
        Sheet sheet=new Sheet();
        sheet.setDoTime(do_time);
        sheet.setPaperId(paperId);
        sheet.setStatus(1);//1-未批改，2-已批改
        sheet.setUserId(userId);
        sheet.setSubmitTime(new Date());
        sheetMapper.insertSelective(sheet);
    }

    /**
     * 首先根据teacherid找到创建的所有试卷，再根据每个paperId找到所有的Sheet即答卷
     * @param teacherId
     * @param before
     * @param after
     * @return
     */
    @Override
    public List<Sheet> findSheetByTeaId(Integer teacherId, int before, int after) {
        //首先找到该老师创建的所有试卷
        List<Sheet>sheetList=new ArrayList<>();
        List<Paper>paperList=new ArrayList<>();
        paperList=paperService.findPaperByCreaterId(teacherId);
        int index=0;
        for (Paper paper:paperList) {
            int paperId=paper.getId();
            SheetExample sheetExample=new SheetExample();
            SheetExample.Criteria criteria=sheetExample.createCriteria();
            criteria.andPaperIdEqualTo(paperId);
            criteria.andStatusEqualTo(1);//所有未批改的试卷
            sheetExample.setOrderByClause("submit_time desc");
            List<Sheet>sublist=new ArrayList<>();
            sublist=sheetMapper.selectByExample(sheetExample);
            for (Sheet sheet: sublist) {
                if(index>=before&&index<=before+after-1){
                    int userid=sheet.getUserId();
                    User user=userService.findUserByUserId(userid);
                    sheet.setUserName(user.getUserName());
                    sheet.setRealName(user.getRealName());
                    //将试卷名称信息放置在答卷上
                    sheet.setPaperName(paper.getPaperName());
                    sheetList.add(sheet);
                }
                index++;
            }
        }
        return sheetList;
    }

    /**
     * 找到该老师出的试卷被提交的答卷的数量
     * @param teacherId
     * @return
     */
    @Override
    public int findSheetCountByTeaId(Integer teacherId) {
        List<Paper>paperList=new ArrayList<>();
        paperList=paperService.findPaperByCreaterId(teacherId);
        int index=0;
        for (Paper paper:paperList) {
            int paperId=paper.getId();
            SheetExample sheetExample=new SheetExample();
            SheetExample.Criteria criteria=sheetExample.createCriteria();
            criteria.andPaperIdEqualTo(paperId);
            criteria.andStatusEqualTo(1);
            List<Sheet>sublist=new ArrayList<>();
            sublist=sheetMapper.selectByExample(sheetExample);
            for (Sheet sheet: sublist) {
                index++;
            }
        }
        return index;
    }

    @Override
    public Sheet findSheetById(Integer sheetId) {
        Sheet sheet=new Sheet();
        sheet=sheetMapper.selectByPrimaryKey(sheetId);
        return sheet;
    }

    @Override
    public void addSheetJudge(Integer userId, Integer paperId, Integer score, String comment) {
        SheetExample sheetExample=new SheetExample();
        SheetExample.Criteria criteria=sheetExample.createCriteria();
        criteria.andPaperIdEqualTo(paperId);
        criteria.andUserIdEqualTo(userId);
        Sheet sheet=new Sheet();
        sheet.setScore(score);
        sheet.setComment(comment);
        sheet.setStatus(2);
        answerService.updateAnswerStatus(userId,paperId);//更新所有相关题目作答的批改状态
        sheetMapper.updateByExampleSelective(sheet,sheetExample);
    }

    @Override
    public List<Sheet> findSheetByUserIdAndPaperId(Integer userId, Integer paperId) {
        SheetExample sheetExample=new SheetExample();
        SheetExample.Criteria criteria=sheetExample.createCriteria();
        criteria.andPaperIdEqualTo(paperId);
        criteria.andUserIdEqualTo(userId);
        List<Sheet>list=new ArrayList<>();
        list=sheetMapper.selectByExample(sheetExample);
        return list;
    }

    @Override
    public List<Sheet> findSheetByUserId(int userId) {
        List<Sheet>list=new ArrayList<>();
        SheetExample sheetExample=new SheetExample();
        SheetExample.Criteria criteria=sheetExample.createCriteria();
        criteria.andUserIdEqualTo(userId);
        sheetExample.setOrderByClause("submit_time desc");
        list=sheetMapper.selectByExample(sheetExample);
        return list;
    }

    @Override
    public List<Sheet> findAllSheetsWithUserHasDone(int userId) {
        List<Sheet>list=new ArrayList<>();
        SheetExample sheetExample=new SheetExample();
        SheetExample.Criteria criteria=sheetExample.createCriteria();
        criteria.andUserIdEqualTo(userId);
        list=sheetMapper.selectByExample(sheetExample);
        List<Sheet>sheetList=new ArrayList<>();
        for(Sheet sheet:list){
            int paperId=sheet.getPaperId();
            Paper paper=paperService.findPaperByPaperId(paperId);
            sheet.setPaperName(paper.getPaperName());
            sheetList.add(sheet);
        }
        return sheetList;
    }

    @Override
    public List<Sheet> findJudgedSheetByTeaId(Integer teacherId, int before, int after) {
        //首先找到该老师创建的所有试卷
        List<Sheet>sheetList=new ArrayList<>();
        List<Paper>paperList=new ArrayList<>();
        paperList=paperService.findPaperByCreaterId(teacherId);
        int index=0;
        for (Paper paper:paperList) {
            int paperId=paper.getId();
            SheetExample sheetExample=new SheetExample();
            SheetExample.Criteria criteria=sheetExample.createCriteria();
            criteria.andPaperIdEqualTo(paperId);
            criteria.andStatusEqualTo(2);//所有批改的试卷
            List<Sheet>sublist=new ArrayList<>();
            sublist=sheetMapper.selectByExample(sheetExample);
            for (Sheet sheet: sublist) {
                if(index>=before&&index<=before+after-1){
                    //将试卷名称信息放置在答卷上
                    sheet.setPaperName(paper.getPaperName());
                    int userid=sheet.getUserId();
                    User user=userService.findUserByUserId(userid);
                    sheet.setUserName(user.getUserName());
                    sheetList.add(sheet);
                }
                index++;
            }
        }
        return sheetList;
    }

    @Override
    public int findJudgedSheetCountByTeaId(Integer teacherId) {
        List<Paper>paperList=new ArrayList<>();
        paperList=paperService.findPaperByCreaterId(teacherId);
        int index=0;
        for (Paper paper:paperList) {
            int paperId=paper.getId();
            SheetExample sheetExample=new SheetExample();
            SheetExample.Criteria criteria=sheetExample.createCriteria();
            criteria.andPaperIdEqualTo(paperId);
            criteria.andStatusEqualTo(2);
            List<Sheet>sublist=new ArrayList<>();
            sublist=sheetMapper.selectByExample(sheetExample);
            for (Sheet sheet: sublist) {
                index++;
            }
        }
        return index;
    }

    @Override
    public void deleteSheetByPaperId(Integer paperId) {
        SheetExample sheetExample=new SheetExample();
        SheetExample.Criteria criteria=sheetExample.createCriteria();
        criteria.andPaperIdEqualTo(paperId);
        sheetMapper.deleteByExample(sheetExample);
    }

    @Override
    public List<Sheet> findAllSheetWithJudged() {
        SheetExample sheetExample=new SheetExample();
        SheetExample.Criteria criteria=sheetExample.createCriteria();
        criteria.andStatusEqualTo(2);
        List<Sheet>sheetList=new ArrayList<>();
        sheetExample.setOrderByClause("submit_time desc");
        sheetList=sheetMapper.selectByExample(sheetExample);
        List<Sheet>list=new ArrayList<>();
        for(Sheet sheet:sheetList){
            int userId=sheet.getUserId();
            int paperId=sheet.getPaperId();
            User doUser=new User();
            doUser=userService.findUserByUserId(userId);
            User judgeUser=new User();
            Paper paper=new Paper();
            paper=paperService.findPaperByPaperId(paperId);
            judgeUser=userService.findUserByUserId(paper.getCreaterId());
            sheet.setUserName(doUser.getUserName());
            sheet.setPaperName(paper.getPaperName());
            sheet.setJudgerName(judgeUser.getUserName());
            list.add(sheet);
        }
        return list;
    }

    @Override
    public Sheet findSheetBySheetId(Integer sheetId) {
        Sheet sheet=sheetMapper.selectByPrimaryKey(sheetId);
        int userId=sheet.getUserId();
        int paperId=sheet.getPaperId();
        User doUser=new User();
        doUser=userService.findUserByUserId(userId);
        User judgeUser=new User();
        Paper paper=new Paper();
        paper=paperService.findPaperByPaperId(paperId);
        judgeUser=userService.findUserByUserId(paper.getCreaterId());
        sheet.setUserName(doUser.getUserName());
        sheet.setPaperName(paper.getPaperName());
        sheet.setJudgerName(judgeUser.getUserName());
        return sheet;
    }

    @Override
    public void updateSheet(Sheet sheet) {
        sheetMapper.updateByPrimaryKeySelective(sheet);
    }

    @Override
    public int findAllJudgedCountWithTeacherId(int userid) {
        List<Paper>paperList=new ArrayList<>();
        paperList=paperService.findPaperByCreaterId(userid);
        int count=0;
        for(Paper paper:paperList){
            int paperId=paper.getId();
            SheetExample sheetExample=new SheetExample();
            SheetExample.Criteria criteria=sheetExample.createCriteria();
            criteria.andStatusEqualTo(2);
            criteria.andPaperIdEqualTo(paperId);
            List<Sheet>sheetList=new ArrayList<>();
            sheetList=sheetMapper.selectByExample(sheetExample);
            count+=sheetList.size();
        }
        return count;
    }

    @Override
    public List<Sheet> searchJudge(Integer sheetId, String paperName, String userName, Integer teacherId, int before, int after) {
        //首先找到该老师创建的所有试卷
        List<Sheet>sheetList=new ArrayList<>();
        List<Paper>paperList=new ArrayList<>();
        if(paperName.equals(""))
            paperList=paperService.findPaperByCreaterId(teacherId);
        else paperList=paperService.findPaperByCreaterIdBlur(teacherId,paperName);
        int index=0;
        for (Paper paper:paperList) {
            int paperId=paper.getId();
            SheetExample sheetExample=new SheetExample();
            SheetExample.Criteria criteria=sheetExample.createCriteria();
            criteria.andPaperIdEqualTo(paperId);
            criteria.andStatusEqualTo(1);//所有未批改的试卷
            List<Sheet>sublist=new ArrayList<>();
            sublist=sheetMapper.selectByExample(sheetExample);
            for (Sheet sheet: sublist) {
                if(index>=before&&index<=before+after-1){
                    if(sheetId!=-1&&sheetId!=sheet.getId()){
                        continue;
                    }
                    //将试卷名称信息放置在答卷上
                    sheet.setPaperName(paper.getPaperName());
                    int userid=sheet.getUserId();
                    User user=userService.findUserByUserId(userid);
                    sheet.setUserName(user.getUserName());
                    String name=user.getUserName();
                    sheet.setRealName(user.getRealName());
                    if(userName.equals("")||name.contains(userName)){
                        sheetList.add(sheet);
                        index++;
                    }
                }
            }
        }
        return sheetList;
    }

    @Override
    public int searchJudgeCount(Integer sheetId, String paperName, String userName, Integer teacherId) {
        //首先找到该老师创建的所有试卷
        List<Sheet>sheetList=new ArrayList<>();
        List<Paper>paperList=new ArrayList<>();
        if(paperName.equals(""))
            paperList=paperService.findPaperByCreaterId(teacherId);
        else paperList=paperService.findPaperByCreaterIdBlur(teacherId,paperName);
        int index=0;
        for (Paper paper:paperList) {
            int paperId=paper.getId();
            SheetExample sheetExample=new SheetExample();
            SheetExample.Criteria criteria=sheetExample.createCriteria();
            if(sheetId!=-1)
                criteria.andPaperIdEqualTo(paperId);
            criteria.andStatusEqualTo(1);//所有未批改的试卷
            List<Sheet>sublist=new ArrayList<>();
            sublist=sheetMapper.selectByExample(sheetExample);
            for (Sheet sheet: sublist) {
                if(sheetId!=-1&&sheetId!=sheet.getId()){
                    continue;
                }
                //将试卷名称信息放置在答卷上
                sheet.setPaperName(paper.getPaperName());
                int userid=sheet.getUserId();
                User user=userService.findUserByUserId(userid);
                sheet.setUserName(user.getUserName());
                String name=user.getUserName();
                sheet.setRealName(user.getRealName());
                if(userName.equals("")||name.contains(userName))
                    index++;
            }
        }
        return index;
    }

    @Override
    public List<Sheet> searchGrade(Integer sheetId, String paperName, String userName, Integer teacherId, int before, int after) {
        //首先找到该老师创建的所有试卷
        List<Sheet>sheetList=new ArrayList<>();
        List<Paper>paperList=new ArrayList<>();
        if(paperName.equals(""))
            paperList=paperService.findPaperByCreaterId(teacherId);
        else paperList=paperService.findPaperByCreaterIdBlur(teacherId,paperName);
        int index=0;
        for (Paper paper:paperList) {
            int paperId=paper.getId();
            SheetExample sheetExample=new SheetExample();
            SheetExample.Criteria criteria=sheetExample.createCriteria();
            criteria.andPaperIdEqualTo(paperId);
            criteria.andStatusEqualTo(2);//所有已批改的试卷
            List<Sheet>sublist=new ArrayList<>();
            sublist=sheetMapper.selectByExample(sheetExample);
            for (Sheet sheet: sublist) {
                if(index>=before&&index<=before+after-1){
                    if(sheetId!=-1&&sheetId!=sheet.getId()){
                        continue;
                    }
                    //将试卷名称信息放置在答卷上
                    sheet.setPaperName(paper.getPaperName());
                    int userid=sheet.getUserId();
                    User user=userService.findUserByUserId(userid);
                    sheet.setUserName(user.getUserName());
                    String name=user.getUserName();
                    sheet.setRealName(user.getRealName());
                    if(userName.equals("")||name.contains(userName)){
                        sheetList.add(sheet);
                        index++;
                    }
                }
            }
        }
        return sheetList;
    }

    @Override
    public int searchGradeCount(Integer sheetId, String paperName, String userName, Integer teacherId) {
        //首先找到该老师创建的所有试卷
        List<Sheet>sheetList=new ArrayList<>();
        List<Paper>paperList=new ArrayList<>();
        if(paperName.equals(""))
            paperList=paperService.findPaperByCreaterId(teacherId);
        else paperList=paperService.findPaperByCreaterIdBlur(teacherId,paperName);
        int index=0;
        for (Paper paper:paperList) {
            int paperId=paper.getId();
            SheetExample sheetExample=new SheetExample();
            SheetExample.Criteria criteria=sheetExample.createCriteria();
            if(sheetId!=-1)
                criteria.andPaperIdEqualTo(paperId);
            criteria.andStatusEqualTo(2);//所有已批改的试卷
            List<Sheet>sublist=new ArrayList<>();
            sublist=sheetMapper.selectByExample(sheetExample);
            for (Sheet sheet: sublist) {
                if(sheetId!=-1&&sheetId!=sheet.getId()){
                    continue;
                }
                //将试卷名称信息放置在答卷上
                sheet.setPaperName(paper.getPaperName());
                int userid=sheet.getUserId();
                User user=userService.findUserByUserId(userid);
                sheet.setUserName(user.getUserName());
                String name=user.getUserName();
                sheet.setRealName(user.getRealName());
                if(userName.equals("")||name.contains(userName))
                    index++;
            }
        }
        return index;
    }

    @Override
    public boolean checkIsAnbswered(Integer userId, Integer paperId) {
        SheetExample sheetExample=new SheetExample();
        SheetExample.Criteria criteria=sheetExample.createCriteria();
        criteria.andPaperIdEqualTo(paperId);
        criteria.andUserIdEqualTo(userId);
        List<Sheet>sheetList=new ArrayList<>();
        sheetList=sheetMapper.selectByExample(sheetExample);
        if(sheetList==null||sheetList.size()==0){
            return false;
        }
        return true;
    }
}

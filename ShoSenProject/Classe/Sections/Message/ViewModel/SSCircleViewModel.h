//
//  SSCircleViewModel.h
//  ShoSenProject
//
//  Created by lifuzhou on 2018/10/30.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SSCircleViewModelBlock)(id obj);

@interface SSCircleViewModel : NSObject

+(SSCircleViewModel *)share;

//删除朋友圈
- (void)delMessageWithMessageID:(NSString *)messageId callBack:(SSCircleViewModelBlock)block;
//发布朋友圈
- (void)addMessageWithContent:(NSString *)content location:(NSString *)location picture:(NSString *)picture   callBack:(SSCircleViewModelBlock)block;

//关注
- (void)addFollowWithUserID:(NSString *)userId follower:(NSString *)follower callBack:(SSCircleViewModelBlock)block;
//取消关注
- (void)delFollowWithUserID:(NSString *)userId follower:(NSString *)follower callBack:(SSCircleViewModelBlock)block;
//关注列表
- (void)followListWithUserID:(NSString *)userId callBack:(SSCircleViewModelBlock)block;


//添加评论
- (void)addCommentWithMessageID:(NSString *)messId content:(NSString *)content parentId:(NSString *)parentId callBack:(SSCircleViewModelBlock)block;
//删除评论
- (void)delCommentWithCommentID:(NSString *)Id callBack:(SSCircleViewModelBlock)block;

//获取圈子个人数据
- (void)userCircleInfoCallBack:(SSCircleViewModelBlock)block;

//好友推荐列表
- (void)userCircleFriendInvitationWithPageNum:(NSString *)pageNum CallBack:(SSCircleViewModelBlock)block;

//个人关注列表
- (void)userCircleSelfFollowWithUserId:(NSString *)userid PageNum:(NSString *)pageNum CallBack:(SSCircleViewModelBlock)block;
//个人消息列表
- (void)userCircleSelfMessageWithUserId:(NSString *)userid content:(NSString*)content PageNum:(NSString *)pageNum CallBack:(SSCircleViewModelBlock)block;
//热门话题
- (void)userCircleHotTopWithPageNum:(NSString *)pageNum CallBack:(SSCircleViewModelBlock)block;

//轮播图列表
- (void)userBannerListBannerListWithType:(NSString *)type  CallBack:(SSCircleViewModelBlock)block;

//评论点赞
- (void)circleUpdateCommentMarkWithCommentId:(NSString *)commentId markStatus:(NSString *)markStatus allBack:(SSCircleViewModelBlock)block;

//朋友圈点赞
- (void)circleUpdateMessMarkWithMessId:(NSString *)messId markStatus:(NSString *)markStatus allBack:(SSCircleViewModelBlock)block;

//图片浏览器
- (void)showBrowserForSimpleCaseWithIndex:(NSInteger)index dataArray:(NSMutableArray *)imageArray;

//我的消息列表
- (void)circleMyReMesssageWithPageNum:(NSString *)pageNum allBack:(SSCircleViewModelBlock)block;
//我的通知消息
- (void)circleNoticeMessCallBack:(SSCircleViewModelBlock)block;
//更多关注
- (void)circleMoreFollowUserId:(NSString *)userId  allBack:(SSCircleViewModelBlock)block;

//举报拉黑
- (void)circleUserCircleReportAndBlacklistWithUserId:(NSString *)userId targetId:(NSString *)targeId type:(NSString*)type reason:(NSString *)reason allBack:(SSCircleViewModelBlock)block;

//取消拉黑
- (void)circleUserCircleCancelBlacklistWithUserId:(NSString *)userId targetId:(NSString *)targetId allBack:(SSCircleViewModelBlock)block;


//我的粉丝
- (void)circleUserCircleSelectFansWithPageNum:(NSString *)PageNum allBack:(SSCircleViewModelBlock)block;

@end
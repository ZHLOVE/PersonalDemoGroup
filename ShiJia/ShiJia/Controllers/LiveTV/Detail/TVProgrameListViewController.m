//
//  TVProgrameListViewController.m
//  ShiJia
//
//  Created by 蒋海量 on 16/6/7.
//  Copyright © 2016年 Ysten.com. All rights reserved.
//

#import "TVProgrameListViewController.h"
#import "ProgramCell.h"
#import "TVDataProvider.h"
#import "TVStationDetail.h"

@interface TVProgrameListViewController ()<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView* programeTabView;
@property (strong, nonatomic) TVProgram* selectedProgram;
@property (nonatomic) BOOL viewAppeared;
@end

@implementation TVProgrameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.programeTabView.separatorColor = kTabLineColor;
    [self p_selectCurrentProgram];
    
    // 下拉刷新
    WEAKSELF
    self.programeTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refashProgramList];
    }];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.viewAppeared = YES;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf p_selectCurrentProgram];
    });
    
    
    

}

- (void)setPrograms:(NSArray *)programs{
    //modify by jianghailiang 20150129
    // _programs = programs;
    _programs = [[programs reverseObjectEnumerator] allObjects];
    //modify end
    
    NSIndexPath* selectedIndexPath = [self.programeTabView indexPathForSelectedRow];
    [self.programeTabView reloadData];
    if (selectedIndexPath && selectedIndexPath.row < self.programs.count) {
        [self.programeTabView selectRowAtIndexPath:selectedIndexPath animated:NO
                              scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)selectProgram:(TVProgram*)program{
    self.selectedProgram = program;
    
    [self p_selectCurrentProgram];
}

- (void)p_selectCurrentProgram{
    if (self.viewAppeared && self.selectedProgram) {
        NSUInteger index = [self.programs indexOfObject:self.selectedProgram];
        if (index != NSNotFound) {
            NSIndexPath* selectedIndexPath = [self.programeTabView indexPathForSelectedRow];
            
            if (selectedIndexPath && selectedIndexPath.row != index) {
                [self.programeTabView deselectRowAtIndexPath:selectedIndexPath animated:YES];
            }
            
            [self.programeTabView selectRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:NO
                                  scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.programs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //modify by jianghailiang
    ProgramCell *cell = [tableView dequeueReusableCellWithIdentifier:cProgramCellID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ProgramCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    TVProgram *tvProgram = self.programs[indexPath.row];
    cell.tvProgram = tvProgram;
    cell.selectionStyle = (tvProgram.canPlay || tvProgram.canReplay) ?UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TVProgram* program = self.programs[indexPath.row];
    
    
    if (program.canPlay || program.canReplay) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:[HiTVConstants HiTVConstantsPlayNotificationName]
         object:self
         userInfo:@{[HiTVConstants HiTVConstantsPlayNotificationVideo]: program,
                    [HiTVConstants HiTVConstantsPlayNotificationVideoList] : self.programs}];
    }
}
-(void)refashProgramList
{
    __weak typeof(self) weakSelf = self;
    [[TVDataProvider sharedInstance] getProgramListForUUID:self.uuid
                                                completion:^(id responseObject) {
                                                    NSArray *tvDateListArray = [[(NSArray*)responseObject reverseObjectEnumerator] allObjects];

                                                    for (TVStationDetail *detaiData in tvDateListArray) {
                                                        if ([detaiData.playDate isEqualToString:self.date.playDate]) {
                                                            self.programs = detaiData.programs;
                                                        }
                                                    }
                                                    [self.programeTabView.mj_header endRefreshing];

                                                } failure:^(NSString *error) {
                                                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                    [weakSelf p_handleNetworkError];
                                                }];
}

EMPTY_TABLE_HEADER
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

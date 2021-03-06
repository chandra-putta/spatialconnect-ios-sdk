/**
 * Copyright 2016 Boundless http://boundlessgeo.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License
 */

#import "SCGpkgDataColumnConstraintsTable.h"
#import "SCGpkgDataColumnConstraint.h"

NSString *const kDCCTableName = @"gpkg_data_column_constraints";
NSString *const kDCCConstraintNameColName = @"constraint_name";
NSString *const kDCCConstraintTypeColName = @"constraint_type";
NSString *const kDCCValueColName = @"value";
NSString *const kDCCMinColName = @"min";
NSString *const kDCCMinIsInclusiveColName = @"minIsInclusive";
NSString *const kDCCMaxColName = @"max";
NSString *const kDCCMaxIsInclusiveColName = @"maxIsInclusive";
NSString *const kDCCDescriptionColName = @"description";

@implementation SCGpkgDataColumnConstraintsTable

- (id)initWithPool:(FMDatabasePool *)p {
  return [super initWithPool:p tableName:kDCCTableName];
}

- (RACSignal *)all {
  NSString *sql = [self allQueryString];
  @weakify(self);
  return
      [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.queue inDatabase:^(FMDatabase *db) {
          FMResultSet *resultSet = [db executeQuery:sql];
          while ([resultSet next]) {
            SCGpkgDataColumnConstraint *e = [[SCGpkgDataColumnConstraint alloc]
                initWithResultSet:resultSet];
            [subscriber sendNext:e];
          }
          [resultSet close];
          [subscriber sendCompleted];
        }];
        return nil;
      }];
}

@end

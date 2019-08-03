### Format of all lines below: Predicate   Old_Filename    New_Filename

evidencePartition   Weight learning 
-----------------------------------
### common to all folds(rename and duplicate in all splits of all learn and eval)
user    users    learn/user_obs.txt <br/>
item    items    learn/item_obs.txt <br/>
users_are_friends    friends.txt    learn/users_are_friends_obs.txt <br/>
sim_content_items_jaccard    sim.items.content.jaccard.above.0.5.boolean    learn/sim_content_items_jaccard_obs.txt <br/>

### common to learn and eval of a particular split(rename and duplicate in learn and eval)
sim_pearson_items    cf-50/cf.f1.train.pearson.sim.items.keep.top.50.boolean    learn/sim_pearson_items_obs.txt <br/>
sim_cosine_items    cf-50/cf.f1.train.cosine.sim.items.keep.top.50.boolean    learn/sim_cosine_items_obs.txt <br/>
#### Note: the equal.1 in filename is unique
sim_adjcos_items    cf-50/cf.f1.train.adjcos.sim.items.keep.equal.1.boolean    learn/sim_adjcos_items_obs.txt <br/>
sim_pearson_users    cf-50/cf.f1.train.pearson.sim.users.keep.top.50.boolean    learn/sim_pearson_users_obs.txt <br/>
sim_cosine_users    cf-50/cf.f1.train.cosine.sim.users.keep.top.50.boolean    learn/sim_cosine_users_obs.txt <br/>

sim_mf_cosine_users    bpmf-similarities/bpmf.u1.base.cosine.sim.users.keep.top.50.boolean    learn/sim_mf_cosine_users_obs.txt <br/>
sim_mf_euclidean_users    bpmf-similarities/bpmf.u1.base.euclidean.sim.users.keep.top.50.boolean    learn/sim_mf_euclidean_users_obs.txt <br/>
sim_mf_cosine_items    bpmf-similarities/bpmf.u1.base.cosine.sim.items.keep.top.50.boolean    learn/sim_mf_cosine_items_obs.txt <br/>
sim_mf_euclidean_items    bpmf-similarities/bpmf.u1.base.euclidean.sim.items.keep.top.50.boolean    learn/sim_mf_euclidean_items_obs.txt <br/>

### files specific to Weight learning (rename only - no duplicating)
avg_user_rating    f1.train.avg.users.ratings    learn/avg_user_rating_obs.txt <br/>
avg_item_rating    f1.train.avg.items.ratings    learn/avg_item_rating_obs.txt <br/>

rated    weight_learning_PSL/rated.1    learn/rated_obs.txt <br/>
sgd_rating    weight_learning_PSL/sgd.predictions.10.factors.fold.1.clean    learn/sgd_rating_obs.txt <br/>
bpmf_rating    weight_learning_PSL/bpmf.predictions.10.factors.fold.1    learn/bpmf_rating_obs.txt <br/>
item_pearson_rating    weight_learning_PSL/10pct.item.based.pearson.top.1.predictions.fold.1.clean     learn/item_pearson_rating_obs.txt <br/>

rating    weight_learning_PSL/90pct.f1.train    learn/rating_obs.txt <br/>

targetPartition   Weight learning
-----------------------------------
rating  weight_learning_PSL/topredict.1    learn/rating_targets.txt <br/>

trueDataPartition   Weight learning
-----------------------------------
rating  weight_learning_PSL/10pct.f1.train    learn/rating_truth.txt <br/>


evidencePartition2   Inference
-----------------------------------
### common to all folds
user    users    eval/user_obs.txt <br/>
item    items    eval/item_obs.txt <br/>
users_are_friends    friends.txt    eval/users_are_friends_obs.txt <br/>
sim_content_items_jaccard    sim.items.content.jaccard.above.0.5.boolean    eval/sim_content_items_jaccard_obs.txt <br/>

avg_user_rating    f1.train.avg.users.ratings    eval/avg_user_rating_obs.txt <br/>
avg_item_rating    f1.train.avg.items.ratings    eval/avg_item_rating_obs.txt <br/>

### common to learn and eval of a particular split
sim_pearson_items    cf-50/cf.f1.train.pearson.sim.items.keep.top.50.boolean    eval/sim_pearson_items_obs.txt <br/>
sim_cosine_items    cf-50/cf.f1.train.cosine.sim.items.keep.top.50.boolean    eval/sim_cosine_items_obs.txt <br/>
sim_adjcos_items    cf-50/cf.f1.train.adjcos.sim.items.keep.equal.1.boolean    eval/sim_adjcos_items_obs.txt <br/>
sim_pearson_users    cf-50/cf.f1.train.pearson.sim.users.keep.top.50.boolean    eval/sim_pearson_users_obs.txt <br/>
sim_cosine_users    cf-50/cf.f1.train.cosine.sim.users.keep.top.50.boolean    eval/sim_cosine_users_obs.txt <br/>

sim_mf_cosine_users    bpmf-similarities/bpmf.u1.base.cosine.sim.users.keep.top.50.boolean    eval/sim_mf_cosine_users_obs.txt <br/>
sim_mf_euclidean_users    bpmf-similarities/bpmf.u1.base.euclidean.sim.users.keep.top.50.boolean    eval/sim_mf_euclidean_users_obs.txt <br/>
sim_mf_cosine_items    bpmf-similarities/bpmf.u1.base.cosine.sim.items.keep.top.50.boolean    eval/sim_mf_cosine_items_obs.txt <br/>
sim_mf_euclidean_items    bpmf-similarities/bpmf.u1.base.euclidean.sim.items.keep.top.50.boolean    eval/sim_mf_euclidean_items_obs.txt <br/>

#### Note learn has 10 factors in the name. eval has 50 factors
sgd_rating    graphlab_results/sgd.predictions.50.factors.fold.1    eval/sgd_rating_obs.txt <br/>
#### Note learn has it 10pct.filename in WL dir. graphlab directory contents 
item_pearson_rating    graphlab_results/item.based.pearson.top.1.predictions.fold.1.clean    eval/item_pearson_rating_obs.txt <br/>
bpmf_rating    pmf-bpmf-predictions/bpmf.predictions.10.factors.fold.1    eval/bpmf_rating_obs.txt <br/>

#### Special case. rated is common to all eval splits. But weight learning rated has different folds per split.
#### Note learn has rated.1 specific to split. rated for eval is common for all. 
rated    rated    eval/rated_obs.txt <br/>

#### files specific to Evaluation (rename only - no duplicating)
rating    f1.yelp.train.clean    eval/rating_obs.txt <br/>

targetPartition   Inference
-----------------------------------
rating  topredict.1    eval/rating_targets.txt <br/>

Evaluation
-----------------------------------
f1.yelp.test.clean    eval/rating_truth.txt <br/>


#### Unused files (not loaded as an predicate) in the dataset per split
cf.f1.train.jaccard.sim.items.keep.top.50.boolean -> deleted from new file organization <br/>
cf.f1.train.jaccard.sim.users.keep.top.50.boolean -> deleted from new file organization <br/>
cf.f1.train.pearsoncorr.items.keep.equal.1.boolean -> deleted from new file organization <br/>

Total files in orignal dataset: 150 <br/>

Total files in reorganized dataset: 220 (10 directories) <br/>
Total files in learn directory of reorganized dataset of a single fold: 22 <br/>
Total files in eval directory of reorganized dataset of a single fold: 22 <br/>


#### Why the original author (Pigi Kouki) may have added attributes about the file to the name of the file?
Maybe to be able to filter (find "regex") based on attribute and then perform operations on it as a group.  <br/>


#### Proof of conversion being done properly on all splits. Files are in accordance with expentations above.
`
shrestabs@[/shresta/views/recsys2015/yelp2ndtry3/0] $ diff -rq eval/ learn/
Files eval/avg_item_rating_obs.txt and learn/avg_item_rating_obs.txt differ
Files eval/avg_user_rating_obs.txt and learn/avg_user_rating_obs.txt differ
Files eval/bpmf_rating_obs.txt and learn/bpmf_rating_obs.txt differ
Files eval/item_pearson_rating_obs.txt and learn/item_pearson_rating_obs.txt differ
Files eval/rated_obs.txt and learn/rated_obs.txt differ
Files eval/rating_obs.txt and learn/rating_obs.txt differ
Files eval/rating_targets.txt and learn/rating_targets.txt differ
Files eval/rating_truth.txt and learn/rating_truth.txt differ
Files eval/sgd_rating_obs.txt and learn/sgd_rating_obs.txt differ
shrestabs@[/shresta/views/recsys2015/yelp2ndtry3/1] $ diff -rq eval/ learn/
Files eval/avg_item_rating_obs.txt and learn/avg_item_rating_obs.txt differ
Files eval/avg_user_rating_obs.txt and learn/avg_user_rating_obs.txt differ
Files eval/bpmf_rating_obs.txt and learn/bpmf_rating_obs.txt differ
Files eval/item_pearson_rating_obs.txt and learn/item_pearson_rating_obs.txt differ
Files eval/rated_obs.txt and learn/rated_obs.txt differ
Files eval/rating_obs.txt and learn/rating_obs.txt differ
Files eval/rating_targets.txt and learn/rating_targets.txt differ
Files eval/rating_truth.txt and learn/rating_truth.txt differ
Files eval/sgd_rating_obs.txt and learn/sgd_rating_obs.txt differ
shrestabs@[/shresta/views/recsys2015/yelp2ndtry3/2] $ diff -rq eval/ learn/
Files eval/avg_item_rating_obs.txt and learn/avg_item_rating_obs.txt differ
Files eval/avg_user_rating_obs.txt and learn/avg_user_rating_obs.txt differ
Files eval/bpmf_rating_obs.txt and learn/bpmf_rating_obs.txt differ
Files eval/item_pearson_rating_obs.txt and learn/item_pearson_rating_obs.txt differ
Files eval/rated_obs.txt and learn/rated_obs.txt differ
Files eval/rating_obs.txt and learn/rating_obs.txt differ
Files eval/rating_targets.txt and learn/rating_targets.txt differ
Files eval/rating_truth.txt and learn/rating_truth.txt differ
Files eval/sgd_rating_obs.txt and learn/sgd_rating_obs.txt differ
shrestabs@[/shresta/views/recsys2015/yelp2ndtry3/3] $ diff -rq eval/ learn/
Files eval/avg_item_rating_obs.txt and learn/avg_item_rating_obs.txt differ
Files eval/avg_user_rating_obs.txt and learn/avg_user_rating_obs.txt differ
Files eval/bpmf_rating_obs.txt and learn/bpmf_rating_obs.txt differ
Files eval/item_pearson_rating_obs.txt and learn/item_pearson_rating_obs.txt differ
Files eval/rated_obs.txt and learn/rated_obs.txt differ
Files eval/rating_obs.txt and learn/rating_obs.txt differ
Files eval/rating_targets.txt and learn/rating_targets.txt differ
Files eval/rating_truth.txt and learn/rating_truth.txt differ
Files eval/sgd_rating_obs.txt and learn/sgd_rating_obs.txt differ
shrestabs@[/shresta/views/recsys2015/yelp2ndtry3/4] $ diff -rq eval/ learn/
Files eval/avg_item_rating_obs.txt and learn/avg_item_rating_obs.txt differ
Files eval/avg_user_rating_obs.txt and learn/avg_user_rating_obs.txt differ
Files eval/bpmf_rating_obs.txt and learn/bpmf_rating_obs.txt differ
Files eval/item_pearson_rating_obs.txt and learn/item_pearson_rating_obs.txt differ
Files eval/rated_obs.txt and learn/rated_obs.txt differ
Files eval/rating_obs.txt and learn/rating_obs.txt differ
Files eval/rating_targets.txt and learn/rating_targets.txt differ
Files eval/rating_truth.txt and learn/rating_truth.txt differ
Files eval/sgd_rating_obs.txt and learn/sgd_rating_obs.txt differ
`

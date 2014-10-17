global configjson
    
% add current directory as the parent directory
parDir = pwd;
% adding evaluation metrics into path
% add jsonlib to path and load the config file


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% pDollarToolBox compiling %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
      pDollarToolBoxPath=[pwd '/dependencies/pDollarToolbox'];
      addpath(genpath(pDollarToolBoxPath));
      toolboxCompile; 

catch exc
      fprintf('Piotr Dollar tool box compilation failed\n');
      fprintf(exc.message);
      fprintf('***************************\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%compiling structured edge detector %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
	cd dependencies/structuredEdges/release/private;
        mex edgesDetectMex.cpp
        mex edgesNmsMex.cpp
        mex spDetectMex.cpp
        mex edgeBoxesMex.cpp
        cd(parDir)
 	fprintf('Compilation of Structured edge detector sucessfully finished\n ');
        fprintf('***************************\n');
catch exc
	fprintf('Compilation of Edge Boxes failed\n ');
        fprintf(exc.message);
        fprintf('***************************\n');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% compilation of edge boxes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
try
	fprintf('Compilation of Edge Boxes started\n ');
	cd edgeBoxes/releaseV3/private/;
	mex edgesDetectMex.cpp
	mex edgesNmsMex.cpp 
	mex spDetectMex.cpp 
	mex edgeBoxesMex.cpp
	cd(parDir)
  	 
        fprintf('Compilation of Edge Boxes sucessfully finished\n ');
	fprintf('***************************\n');
catch exc
        fprintf('Compilation of Edge Boxes failed\n ');
	fprintf(exc.message);
	fprintf('***************************\n');
end
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% building MCG and installation%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
	fprintf('Compilation of MCG started\n ');
	mcg_path = [pwd '/mcg/MCG-Full'];
	addpath(genpath([pwd '/mcg']));
	%set root_dir for mcg
	mcgRootDir = mcg_root_dir(mcg_path);
        boostPath='/opt/local/include/';
	%build and install
	mcg_build(mcgRootDir, boostPath);
	mcg_install(mcgRootDir);
	fprintf('Compilation of MCG sucessfully finished\n ');
        fprintf('***************************\n');
catch exc
    fprintf('Compilation of MCG failed\n ');
    fprintf(exc.message);
    fprintf('***************************');
end


%%%%%%%%%%%%%%%%%%%%%%%
%% building Endres %%%%
%%%%%%%%%%%%%%%%%%%%%%%
%noothing to do
%{
try
     fprintf('Compilation of Endres started\n ');
    endres_path = [pwd '/endres/proposals'];
    configjson.endres.endrespath = endres_path;
    addpath(genpath(endres_path));
    fprintf('Compilation of Endres sucessfully finished\n ');
    fprintf('***************************\n');
catch exc
    fprintf('Compilation of Endres failed\n ');
    fprintf(exc.message);
    fprintf('***************************\n');
end
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% building rantalankila %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    fprintf('Compilation of Rantalankila Segments started\n ');
    vlfeatpath = [ pwd '/dependencies/vlfeat-0.9.16/' ];
    run(fullfile(vlfeatpath, 'toolbox/vl_setup'));
    cd([pwd '/dependencies/GCMex/']);
    GCMex_compile;
    cd(parDir);
    fprintf('Compilation of Rantalankila Segments successfully finished\n ');
    fprintf('***************************\n');
catch exc
    fprintf('Compilation of Rantalankila failed\n ');
    fprintf(exc.message);
    fprintf('***************************\n');
end

%%%%%%%%%%%%%%%%%%%%
%% building rahtu %%
%%%%%%%%%%%%%%%%%%%%

try
    fprintf('Compilation of Rahtu started\n ');
    addpath(genpath([pwd '/rahtu']));
    rahtuPath = [pwd '/rahtu/rahtuObjectness'];
    compileObjectnessMex(rahtuPath);
    fprintf('Compilation of Rahtu successfully finished\n ');
    fprintf('***************************\n');
catch exc
    fprintf('Compilation of Rahtu failed\n ');
    fprintf(exc.message);
    fprintf('***************************\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% building randomizedPrims%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    fprintf('Compilation of Randomized Prims started\n ');
    rpPath = [pwd, '/randomizedPrims/rp-master'];
    addpath(genpath(rpPath))
    setupRandomizedPrim(rpPath);
    fprintf('Compilation of Randomized Prims successfully finished\n ');
    fprintf('***************************\n');
catch exc
    fprintf('Compilation of Randomized Prims failed\n ');
    fprintf(exc.message);
    fprintf('***************************\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%% building objectness %%
%%%%%%%%%%%%%%%%%%%%%%%%%

%nothing to do
%{
try
    fprintf('Compiling Objectness \n');
    addpath(genpath([pwd, '/objectness-release-v2.2']));
    configjson.objectness.objectnesspath = [pwd, '/objectness-release-v2.2'];
    params=defaultParams(configjson.objectness.objectnesspath);

    configjson.objectness.params=params;
    fprintf('Compiling Objectness succesfully finished \n');
    fprintf('***************************\n');
catch exc
   fprintf('Compilation of Objectness failed\n ');
   fprintf(exc.message);
   fprintf('***************************\n');
end

%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% building selective_search %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
	fprintf('Compiling Selective Search \n');
	mex 'selective_search/Dependencies/anigaussm/anigauss_mex.c' 'selective_search/Dependencies/anigaussm/anigauss.c' -output anigauss -outdir 'selective_search'
	mex 'selective_search/Dependencies/mexCountWordsIndex.cpp' -outdir 'selective_search'
	mex 'selective_search/Dependencies/FelzenSegment/mexFelzenSegmentIndex.cpp' -output mexFelzenSegmentIndex -outdir 'selective_search'
    fprintf('Compiling Selective Search succesfully finished \n');
    fprintf('***************************\n');
catch exc
    fprintf('Compilation of Selective Search failed\n ');
    fprintf(exc.message);
    fprintf('***************************\n');
end



%%%%%%%%%%%%%%%%%%%%
%% building rigor %%
%%%%%%%%%%%%%%%%%%%%
%{
try
	
  fprintf('eval statements\n');
   % mex code
   eval(sprintf('mex -O %s/intens_pixel_diff_mex.c -output %s/intens_pixel_diff_mex', utils_dir, utils_dir));
   eval(sprintf('mex -O %s/prctile_feats.cpp -output %s/prctile_feats', utils_dir, utils_dir));
   eval(sprintf('mex -O %s/region_centroids_mex.cpp -output %s/region_centroids_mex', utils_dir, utils_dir));
   eval(sprintf('mex -O %s/superpix_regionprops.cpp -output %s/superpix_regionprops', utils_dir, utils_dir));
   eval(sprintf('mex -O %s/sp_conncomp_mex.cpp %s -output %s/sp_conncomp_mex', utils_dir, boost_incl_opt, utils_dir));
   eval(sprintf(['mex -O ', ...
       '%s/segm_overlap_mex.cpp ', ...
       '%s/overlap.cpp ', ...
       '-output %s/segm_overlap_mex'], utils_dir, utils_dir, utils_dir));
   eval(sprintf('mex -O %s/convert_masks.cpp -output %s/convert_masks', utils_dir, utils_dir));
   eval(sprintf(['mex -O ', ...
       '%s/overlap_over_threshold.cpp ', ...
       'CFLAGS="\\$CFLAGS -fopenmp" LDFLAGS="\\$LDFLAGS -fopenmp" ', ...
       '-output %s/overlap_over_threshold'], utils_dir, utils_dir));
   eval(sprintf('mex -O %s/para_pseudoflow/hoch_pseudo_par.c -output %s/para_pseudoflow/hoch_pseudo_par', extern_dir, extern_dir));
   eval(sprintf(['mex -O ', ...
       '%s/bk_dynamicgraphs_mex.cpp ', ...
       '%s/dynamicgraphs/bk_nodynamic.cpp ', ...
       '%s/dynamicgraphs/bk_kohli.cpp ', ...
       '%s/dynamicgraphs/bk_multiseeddynamic.cpp ', ...
       '%s/dynamicgraphs/bk_utils.cpp %s %s %s -ltbb ', ...
       'LDFLAGS="\\$LDFLAGS %s -lboost_system-mt -lboost_timer-mt %s" ', ...
       '-output %s/bk_dynamicgraphs_mex;'], ...
       boykov_dir, boykov_dir, boykov_dir, boykov_dir, boykov_dir, ...
       boost_incl_opt, tbb_incl_opt, tbb_lib_opt, boost_lib_opt, ...
       extra_opts, boykov_dir));
   
       fprintf('Compiling RIGOR succesfully finished \n');

catch exc
    fprintf('Compilation of RIGOR failed\n ');
    fprintf(exc.message);
    fprintf('***************************\n');
end
%}

  fprintf('******Compiling complete.*********\n')

#####################################
### -- wflower project creator -- ###
#####################################

# - Test
wflower_TAG           = test123
wflower_CONFIG        = ParamSpace_Hybrid_modified_mA_mHc_test.config
wflower_WRITELHA      = 0
wflower_nJOBS         = 1
wflower_BINARY        = binary
wflower_yukawa_TYPE   = 2
wflower_WORK_DIR       = ~/lib/sandbox/wflower

#wflower_JOB_RESRCLIST =
#wflower_JOB-RESRCLIST = "walltime=8:00:00"

#######################################
### --- wflower data formatting --- ###
#######################################

wflower_format_data_work_dir  = ~/lib/sandbox/wflower
wflower_format_data_tag       = EWPO_survey_mH_mHc_from_200_to_600_9_9_bins
wflower_format_data_mA        = 200.0
wflower_format_data_mH        = 500.0
wflower_format_data_mHc       = 600.0
wflower_format_data_out_label = formatted_dat_mA_$(wflower_format_data_mA)_mH_$(wflower_format_data_mH)_mHc_$(wflower_format_data_mHc)
wflower_format_data_mask      = EWPO_custom_mA_mH_mHc.mask
wflower_format_data_eval      = mA='$(wflower_format_data_mA)' mH='$(wflower_format_data_mH)' mHc='$(wflower_format_data_mHc)'

#################################
### --- wflower plot data --- ###
#################################

wflower_fig_work_dir       = ~/lib/sandbox/wflower/
wflower_fig_tag            = $(wflower_format_data_tag)
wflower_fig_out_label      = $(wflower_format_data_out_label)
wflower_fig_gnuplot_script = plot_EWPO.gnu

#wflower_fig_mask  = EWPO.mask
#wflower_fig_eval  = mA='150.0' mh='150'

VAR_wflower    = $(shell echo '$(.VARIABLES)' |  awk -v RS=' ' '/^wflower_/' | sed 's/wflower_//g' )
EXPORT_wflower = $(foreach v,$(VAR_wflower),$(v)="$(wflower_$(v))")

test : .PHONY
	@echo "This is wflower_format_data_eval:"
	@echo "$(wflower_format_data_eval)"

wflower :
	@$(EXPORT_wflower) ./wflower-utils/wflower-m-create-project.sh

wflower-check :
	@$(EXPORT_wflower) ./wflower-utils/wflower-s-check-setup.sh

wflower-merge :
	@$(EXPORT_wflower) ./wflower-utils/wflower-s-merge-processed-files.sh

wflower-submit-jobs :
	@$(EXPORT_wflower) ./wflower-utils/wflower-s-submit-jobs.sh

wflower-format-data :
	@$(EXPORT_wflower) $(wflower_format_data_eval) ./wflower-utils/wflower-s-format-data.sh

wflower-plot-data :
	@$(EXPORT_wflower) ./wflower-utils/wflower-s-plot-data.sh

build : build_allbinaries

build_allbinaries : 
	@ cd src; make binaries;

clean :
	rm -f ./lib/*.o
	find ./bin/ -type f -not -name 'dummy' | xargs rm -f
	rm -f ./src/.depend_cpp
	touch ./src/.depend_cpp

.PHONY:

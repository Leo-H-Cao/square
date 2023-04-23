# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
namespace eval ::optrace {
  variable script "C:/Users/lhc22/Desktop/square/square.runs/synth_1/VGAController.tcl"
  variable category "vivado_synth"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
OPTRACE "synth_1" START { ROLLUP_AUTO }
set_param chipscope.maxJobs 3
set_param xicom.use_bs_reader 1
OPTRACE "Creating in-memory project" START { }
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/lhc22/Desktop/square/square.cache/wt [current_project]
set_property parent.project_path C:/Users/lhc22/Desktop/square/square.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/lhc22/Desktop/square/square.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
OPTRACE "Creating in-memory project" END { }
OPTRACE "Adding files" START { }
read_mem {
  C:/Users/lhc22/Desktop/square/sprites.mem
  C:/Users/lhc22/Desktop/square/ascii.mem
  C:/Users/lhc22/Desktop/square/colors.mem
  C:/Users/lhc22/Desktop/square/image.mem
  {C:/Users/lhc22/Desktop/square/Test Files/Memory Files/square.mem}
  C:/Users/lhc22/Desktop/square/start_screen.mem
  C:/Users/lhc22/Desktop/square/start_screen_colors.mem
}
read_verilog -library xil_defaultlib {
  C:/Users/lhc22/Desktop/square/RAM.v
  C:/Users/lhc22/Desktop/square/ROM.v
  C:/Users/lhc22/Desktop/square/VGARAM.v
  C:/Users/lhc22/Desktop/square/VGATimingGenerator.v
  C:/Users/lhc22/Desktop/square/Wrapper.v
  C:/Users/lhc22/Desktop/square/alu.v
  C:/Users/lhc22/Desktop/square/and_32.v
  C:/Users/lhc22/Desktop/square/bypass.v
  C:/Users/lhc22/Desktop/square/cla32.v
  C:/Users/lhc22/Desktop/square/cla8.v
  C:/Users/lhc22/Desktop/square/counter.v
  C:/Users/lhc22/Desktop/square/decoder32.v
  C:/Users/lhc22/Desktop/square/dffe_ref.v
  C:/Users/lhc22/Desktop/square/dffe_ref_falling.v
  C:/Users/lhc22/Desktop/square/divide.v
  C:/Users/lhc22/Desktop/square/full_adder.v
  C:/Users/lhc22/Desktop/square/invert.v
  C:/Users/lhc22/Desktop/square/latch_dx.v
  C:/Users/lhc22/Desktop/square/latch_fd.v
  C:/Users/lhc22/Desktop/square/latch_multdiv.v
  C:/Users/lhc22/Desktop/square/latch_mw.v
  C:/Users/lhc22/Desktop/square/latch_xm.v
  C:/Users/lhc22/Desktop/square/leftshift_1.v
  C:/Users/lhc22/Desktop/square/leftshift_16.v
  C:/Users/lhc22/Desktop/square/leftshift_2.v
  C:/Users/lhc22/Desktop/square/leftshift_32.v
  C:/Users/lhc22/Desktop/square/leftshift_4.v
  C:/Users/lhc22/Desktop/square/leftshift_8.v
  C:/Users/lhc22/Desktop/square/mult_control.v
  C:/Users/lhc22/Desktop/square/multdiv.v
  C:/Users/lhc22/Desktop/square/multdiv_control.v
  C:/Users/lhc22/Desktop/square/multiply.v
  C:/Users/lhc22/Desktop/square/mux_2.v
  C:/Users/lhc22/Desktop/square/mux_2_5bit.v
  C:/Users/lhc22/Desktop/square/mux_4.v
  C:/Users/lhc22/Desktop/square/mux_4_5bit.v
  C:/Users/lhc22/Desktop/square/mux_8.v
  C:/Users/lhc22/Desktop/square/mux_8_5bit.v
  C:/Users/lhc22/Desktop/square/or_32.v
  C:/Users/lhc22/Desktop/square/pc_control.v
  C:/Users/lhc22/Desktop/square/processor.v
  C:/Users/lhc22/Desktop/square/reg64.v
  C:/Users/lhc22/Desktop/square/reg65.v
  C:/Users/lhc22/Desktop/square/regfile.v
  C:/Users/lhc22/Desktop/square/register.v
  C:/Users/lhc22/Desktop/square/register32.v
  C:/Users/lhc22/Desktop/square/register32_neg.v
  C:/Users/lhc22/Desktop/square/rightshift_1.v
  C:/Users/lhc22/Desktop/square/rightshift_16.v
  C:/Users/lhc22/Desktop/square/rightshift_2.v
  C:/Users/lhc22/Desktop/square/rightshift_32.v
  C:/Users/lhc22/Desktop/square/rightshift_4.v
  C:/Users/lhc22/Desktop/square/rightshift_8.v
  C:/Users/lhc22/Desktop/square/tff.v
  C:/Users/lhc22/Desktop/square/tri_state.v
  C:/Users/lhc22/Desktop/square/VGAController.v
}
OPTRACE "Adding files" END { }
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/lhc22/Downloads/newconstraints.xdc
set_property used_in_implementation false [get_files C:/Users/lhc22/Downloads/newconstraints.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

OPTRACE "synth_design" START { }
synth_design -top VGAController -part xc7a100tcsg324-1
OPTRACE "synth_design" END { }
if { [get_msg_config -count -severity {CRITICAL WARNING}] > 0 } {
 send_msg_id runtcl-6 info "Synthesis results are not added to the cache due to CRITICAL_WARNING"
}


OPTRACE "write_checkpoint" START { CHECKPOINT }
# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef VGAController.dcp
OPTRACE "write_checkpoint" END { }
OPTRACE "synth reports" START { REPORT }
create_report "synth_1_synth_report_utilization_0" "report_utilization -file VGAController_utilization_synth.rpt -pb VGAController_utilization_synth.pb"
OPTRACE "synth reports" END { }
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
OPTRACE "synth_1" END { }

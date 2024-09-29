// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
import ScheduleEditController from "./schedule_edit_controller"
import ShiftManagementController from "./shift_management_controller"
application.register("schedule-edit", ScheduleEditController)
application.register("shift-management", ShiftManagementController)

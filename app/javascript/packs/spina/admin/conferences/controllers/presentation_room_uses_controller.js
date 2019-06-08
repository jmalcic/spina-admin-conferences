import { RecordListController } from './record_list_controller'
import Routes from '../../../../../routes.js.erb'

export default class extends RecordListController {
  constructor(context) {
    super(context)
    this.route = Routes.spina_admin_conferences_presentation_type_room_uses_path
    this.optionLabel = 'room_name'
  }
}

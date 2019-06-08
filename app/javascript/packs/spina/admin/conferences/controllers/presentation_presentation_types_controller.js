import { RecordListController } from './record_list_controller'
import Routes from '../../../../../routes.js.erb'

export default class extends RecordListController {
  constructor(context) {
    super(context)
    this.route = Routes.spina_admin_conferences_conference_presentation_types_path
    this.optionLabel = 'name'
  }
}

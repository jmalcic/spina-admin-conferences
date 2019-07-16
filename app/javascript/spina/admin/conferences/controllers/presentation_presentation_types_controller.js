import { RecordListController } from './record_list_controller'

export class PresentationPresentationTypesController extends RecordListController {
  constructor(context) {
    super(context)
    this.optionLabel = 'name'
  }
}

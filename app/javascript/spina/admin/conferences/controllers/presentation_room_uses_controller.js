import { RecordListController } from './record_list_controller'

export class PresentationRoomUsesController extends RecordListController {
  constructor(context) {
    super(context)
    this.optionLabel = 'room_name'
  }
}

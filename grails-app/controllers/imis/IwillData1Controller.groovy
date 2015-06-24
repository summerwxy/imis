package imis

import org.springframework.dao.DataIntegrityViolationException

class IwillData1Controller extends BaseController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        [iwillData1InstanceList: IwillData1.list(params), iwillData1InstanceTotal: IwillData1.count()]
    }

    def create() {
        [iwillData1Instance: new IwillData1(params)]
    }

    def save() {
        def iwillData1Instance = new IwillData1(params)
        if (!iwillData1Instance.save(flush: true)) {
            render(view: "create", model: [iwillData1Instance: iwillData1Instance])
            return
        }

        flash.message = message(code: 'default.created.message', args: [message(code: 'iwillData1.label', default: 'IwillData1'), iwillData1Instance.id])
        redirect(action: "show", id: iwillData1Instance.id)
    }

    def show(Long id) {
        def iwillData1Instance = IwillData1.get(id)
        if (!iwillData1Instance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'iwillData1.label', default: 'IwillData1'), id])
            redirect(action: "list")
            return
        }

        [iwillData1Instance: iwillData1Instance]
    }

    def edit(Long id) {
        def iwillData1Instance = IwillData1.get(id)
        if (!iwillData1Instance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'iwillData1.label', default: 'IwillData1'), id])
            redirect(action: "list")
            return
        }

        [iwillData1Instance: iwillData1Instance]
    }

    def update(Long id, Long version) {
        def iwillData1Instance = IwillData1.get(id)
        if (!iwillData1Instance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'iwillData1.label', default: 'IwillData1'), id])
            redirect(action: "list")
            return
        }

        if (version != null) {
            if (iwillData1Instance.version > version) {
                iwillData1Instance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'iwillData1.label', default: 'IwillData1')] as Object[],
                          "Another user has updated this IwillData1 while you were editing")
                render(view: "edit", model: [iwillData1Instance: iwillData1Instance])
                return
            }
        }

        iwillData1Instance.properties = params

        if (!iwillData1Instance.save(flush: true)) {
            render(view: "edit", model: [iwillData1Instance: iwillData1Instance])
            return
        }

        flash.message = message(code: 'default.updated.message', args: [message(code: 'iwillData1.label', default: 'IwillData1'), iwillData1Instance.id])
        redirect(action: "show", id: iwillData1Instance.id)
    }

    def delete(Long id) {
        def iwillData1Instance = IwillData1.get(id)
        if (!iwillData1Instance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'iwillData1.label', default: 'IwillData1'), id])
            redirect(action: "list")
            return
        }

        try {
            iwillData1Instance.delete(flush: true)
            flash.message = message(code: 'default.deleted.message', args: [message(code: 'iwillData1.label', default: 'IwillData1'), id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'iwillData1.label', default: 'IwillData1'), id])
            redirect(action: "show", id: id)
        }
    }
}

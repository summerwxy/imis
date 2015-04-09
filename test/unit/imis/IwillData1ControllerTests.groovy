package imis



import org.junit.*
import grails.test.mixin.*

@TestFor(IwillData1Controller)
@Mock(IwillData1)
class IwillData1ControllerTests {

    def populateValidParams(params) {
        assert params != null
        // TODO: Populate valid properties like...
        //params["name"] = 'someValidName'
    }

    void testIndex() {
        controller.index()
        assert "/iwillData1/list" == response.redirectedUrl
    }

    void testList() {

        def model = controller.list()

        assert model.iwillData1InstanceList.size() == 0
        assert model.iwillData1InstanceTotal == 0
    }

    void testCreate() {
        def model = controller.create()

        assert model.iwillData1Instance != null
    }

    void testSave() {
        controller.save()

        assert model.iwillData1Instance != null
        assert view == '/iwillData1/create'

        response.reset()

        populateValidParams(params)
        controller.save()

        assert response.redirectedUrl == '/iwillData1/show/1'
        assert controller.flash.message != null
        assert IwillData1.count() == 1
    }

    void testShow() {
        controller.show()

        assert flash.message != null
        assert response.redirectedUrl == '/iwillData1/list'

        populateValidParams(params)
        def iwillData1 = new IwillData1(params)

        assert iwillData1.save() != null

        params.id = iwillData1.id

        def model = controller.show()

        assert model.iwillData1Instance == iwillData1
    }

    void testEdit() {
        controller.edit()

        assert flash.message != null
        assert response.redirectedUrl == '/iwillData1/list'

        populateValidParams(params)
        def iwillData1 = new IwillData1(params)

        assert iwillData1.save() != null

        params.id = iwillData1.id

        def model = controller.edit()

        assert model.iwillData1Instance == iwillData1
    }

    void testUpdate() {
        controller.update()

        assert flash.message != null
        assert response.redirectedUrl == '/iwillData1/list'

        response.reset()

        populateValidParams(params)
        def iwillData1 = new IwillData1(params)

        assert iwillData1.save() != null

        // test invalid parameters in update
        params.id = iwillData1.id
        //TODO: add invalid values to params object

        controller.update()

        assert view == "/iwillData1/edit"
        assert model.iwillData1Instance != null

        iwillData1.clearErrors()

        populateValidParams(params)
        controller.update()

        assert response.redirectedUrl == "/iwillData1/show/$iwillData1.id"
        assert flash.message != null

        //test outdated version number
        response.reset()
        iwillData1.clearErrors()

        populateValidParams(params)
        params.id = iwillData1.id
        params.version = -1
        controller.update()

        assert view == "/iwillData1/edit"
        assert model.iwillData1Instance != null
        assert model.iwillData1Instance.errors.getFieldError('version')
        assert flash.message != null
    }

    void testDelete() {
        controller.delete()
        assert flash.message != null
        assert response.redirectedUrl == '/iwillData1/list'

        response.reset()

        populateValidParams(params)
        def iwillData1 = new IwillData1(params)

        assert iwillData1.save() != null
        assert IwillData1.count() == 1

        params.id = iwillData1.id

        controller.delete()

        assert IwillData1.count() == 0
        assert IwillData1.get(iwillData1.id) == null
        assert response.redirectedUrl == '/iwillData1/list'
    }
}

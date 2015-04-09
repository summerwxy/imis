package imis

import org.zkoss.zk.grails.composer.*

import org.zkoss.zk.ui.select.annotation.Wire
import org.zkoss.zk.ui.select.annotation.Listen
import org.zkoss.zk.ui.event.*
import org.zkoss.zul.*
import org.zkoss.zk.ui.select.*
import iwill.*





class Iwill_002Composer extends GrailsComposer {

    def the_store
    def the_store2

    def afterCompose = { window ->
        // initialize components here
        // render PART_MENU_D list
        def sql = _.sql
        def list = []
        def s = """
            SELECT S_NO, S_NAME
            FROM STORE
            ORDER BY S_NAME
        """
        sql.eachRow(s, []) {
            list << it.toRowResult()
        }
        the_store.model = new ListModelList(list)
        // the_store2.model = new ListModelList(list)

        /*
        sandboxes.setOptionRenderer(new OptionRenderer<FiddleSandboxGroup>() {
            public void render(Selectbox box,OptionBuilder builder, FiddleSandboxGroup group) throws Exception {
                if(group.getName().indexOf(".FL") != -1){
                    group.setName(group.getName().replaceAll("\\.FL", " Freshly"));
                }
                builder.appendOptionGroup(group.getName(), group.getSandboxs(), new OptionRenderer<FiddleSandbox>() { 
                    public void render(Selectbox box,OptionBuilder builder, FiddleSandbox sandbox) throws Exception {
                        builder.appendOption(sandbox.getName() +"["+sandbox.getZKVersion()+"]" , sandbox.getHash(),sandbox);
                    };
                });

            }
        });
        sandboxes.setModel(new ListModelList(sandboxManager.getFiddleSandboxGroups()));
        */
        /*
        the_store2.setOptionRenderer(new OptionRenderer() {
            public void render() throws Exception {
            
            } 
        })
        */

    }
}

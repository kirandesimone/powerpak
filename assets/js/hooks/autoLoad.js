const AutoLoad = {
    mounted() {
        window.onload = this.trigger_event() 
    },
    trigger_event() {
        this.pushEvent("load", {})
    }
}

export default AutoLoad
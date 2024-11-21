import { Agora } from '@swipelive&#x2F;capacitor-agora';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    Agora.echo({ value: inputValue })
}

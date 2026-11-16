/* =====================================================================
   TRADUTOR (translate) - tradução entre os idiomas do telemóvel (locales.js L.NAMES) pelo Gemini do servidor
   (server/translate.lua, a mesma chave da Vera Chat) + Frasário OFFLINE embutido (120 frases de RP em PT, EN,
   ES, FR, DE e IT). Separadores: Texto (origem, troca, resultado grande, Copiar / Enviar por mensagem / Favorito),
   Conversa (dois lados, cada um na sua língua), Frasário (categorias + pesquisa) e Guardado (favoritos e histórico).
   Sem chave no servidor a app explica e cai no frasário. PearOS e Nova UI no mesmo ficheiro (CSS app-translate.css).
   ===================================================================== */
(() => {
  const SQ = 'M50 0C88 0 100 12 100 50S88 100 50 100 0 88 0 50 12 0 50 0Z';
  /* ícone PearOS: duas bolhas de conversa (uma clara, uma azul) e um pequeno globo: sem letras (um SVG em imagem não vê as fontes) */
  Icons.app.translate = () => Icons.SVG(Icons.G('gTrl', '#4FA8FF', '#1C78F0', '#0C56C8') + Icons.GL(
    '<path d="M18 26a9 9 0 0 1 9-9h26a9 9 0 0 1 9 9v16a9 9 0 0 1-9 9H36l-11 9v-9h-.5A6.5 6.5 0 0 1 18 44.5z" fill="#fff"/>'
    + '<g fill="none" stroke="#1C78F0" stroke-width="3.4" stroke-linecap="round"><path d="M28 30h18M37 30v-3M30 38c6-1 10-4 12-8M32 31c2 4 5 6 10 7"/></g>'
    + '<path d="M38 54a9 9 0 0 1 9-9h26a9 9 0 0 1 9 9v16a9 9 0 0 1-9 9h-1v9l-11-9H47a9 9 0 0 1-9-9z" fill="#0A3C8C"/>'
    + '<g fill="none" stroke="#fff" stroke-width="3.4" stroke-linecap="round" stroke-linejoin="round"><circle cx="60" cy="62" r="8.5"/><path d="M51.5 62h17M60 53.5c3 2.6 4.6 5.4 4.6 8.5S63 68 60 70.5M60 53.5c-3 2.6-4.6 5.4-4.6 8.5S57 68 60 70.5"/></g>'));
  if (Icons.registerOS) Icons.registerOS('android', { translate: () => Icons.SVG(
    `<path d="${SQ}" fill="#2D6DF6"/><ellipse cx="38" cy="8" rx="70" ry="44" fill="#7FB0FF" opacity=".45"/><path d="${SQ}" fill="none" stroke="#fff" stroke-opacity=".26" stroke-width="2.2"/>`
    + '<path d="M16 28a10 10 0 0 1 10-10h26a10 10 0 0 1 10 10v16a10 10 0 0 1-10 10H36l-11 9v-9A10 10 0 0 1 16 44z" fill="#D6E6FF"/>'
    + '<path d="M16 28a10 10 0 0 1 10-10h26a10 10 0 0 1 10 10v16a10 10 0 0 1-10 10H36l-11 9v-9A10 10 0 0 1 16 44z" fill="#fff" transform="translate(-2 -1.5)"/>'
    + '<g fill="none" stroke="#2D6DF6" stroke-width="3.6" stroke-linecap="round"><path d="M25 29h17M33.5 29v-3M27 37c6-1 10-4 12-8M29 30c2 4 5 6 10 7"/></g>'
    + '<path d="M38 56a10 10 0 0 1 10-10h26a10 10 0 0 1 10 10v16a10 10 0 0 1-10 10h-1v9l-11-9H48a10 10 0 0 1-10-10z" fill="#0F3E9E"/>'
    + '<g fill="none" stroke="#fff" stroke-width="3.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="61" cy="64" r="8.5"/><path d="M52.5 64h17M61 55.5c3 2.6 4.6 5.4 4.6 8.5S64 70 61 72.5M61 55.5c-3 2.6-4.6 5.4-4.6 8.5S58 70 61 72.5"/></g>', true) });
  if (window.App && App.alias) App.alias('android', { translate: 'Tradutor' });
  try { if (UI.OU_APPS && UI.OU_APPS.add) UI.OU_APPS.add('translate'); } catch (e) {}

  const isA = () => !!(window.System && System.isAndroid && System.isAndroid());
  const T = s => (window.L && L.t ? L.t(s) : s);
  const TF = (s, ...v) => (window.L && L.tf ? L.tf(s, ...v) : v.reduce((a, x) => a.replace('%s', x), s));
  const LANG_ORDER = () => (window.L && Array.isArray(L.ORDER) && L.ORDER.length ? L.ORDER.slice() : ['en', 'es', 'zh-Hans', 'zh-Hant', 'ja', 'fr', 'de', 'ru', 'pt', 'it', 'ko', 'nl', 'tr', 'pl', 'sv', 'da']);
  const langName = c => c === 'auto' ? T('Detetar idioma') : ((window.L && L.NAMES && L.NAMES[c]) || c);
  const phoneLang = () => { const c = window.System && System.state && System.state.lang; return c && window.L && L.NAMES && L.NAMES[c] ? c : 'pt'; };
  const MAX_CHARS = 1000;

  /* ---------- FRASÁRIO OFFLINE: pt | en | es | fr | de | it ---------- */
  const PB_LANGS = ['pt', 'en', 'es', 'fr', 'de', 'it'];
  const PB = {
    'Cumprimentos': [
      'Olá, tudo bem?|Hello, how are you?|Hola, ¿qué tal?|Bonjour, ça va ?|Hallo, wie geht es dir?|Ciao, come stai?',
      'Bom dia|Good morning|Buenos días|Bonjour|Guten Morgen|Buongiorno',
      'Boa tarde|Good afternoon|Buenas tardes|Bon après-midi|Guten Tag|Buon pomeriggio',
      'Boa noite|Good evening|Buenas noches|Bonsoir|Guten Abend|Buonasera',
      'Chamo-me...|My name is...|Me llamo...|Je m\'appelle...|Ich heiße...|Mi chiamo...',
      'Como te chamas?|What is your name?|¿Cómo te llamas?|Comment tu t\'appelles ?|Wie heißt du?|Come ti chiami?',
      'Prazer em conhecer-te|Nice to meet you|Encantado de conocerte|Enchanté|Freut mich, dich kennenzulernen|Piacere di conoscerti',
      'Obrigado|Thank you|Gracias|Merci|Danke|Grazie',
      'De nada|You\'re welcome|De nada|De rien|Gern geschehen|Prego',
      'Desculpa|Sorry|Perdón|Désolé|Entschuldigung|Scusa',
      'Não percebo|I don\'t understand|No entiendo|Je ne comprends pas|Ich verstehe nicht|Non capisco',
      'Podes repetir, por favor?|Can you repeat, please?|¿Puedes repetir, por favor?|Peux-tu répéter, s\'il te plaît ?|Kannst du das bitte wiederholen?|Puoi ripetere, per favore?',
      'Falas inglês?|Do you speak English?|¿Hablas inglés?|Parles-tu anglais ?|Sprichst du Englisch?|Parli inglese?',
      'Até logo|See you later|Hasta luego|À plus tard|Bis später|A dopo',
      'Adeus|Goodbye|Adiós|Au revoir|Auf Wiedersehen|Arrivederci',
    ],
    'Polícia': [
      'Mãos à vista, por favor|Hands where I can see them, please|Las manos a la vista, por favor|Les mains bien visibles, s\'il vous plaît|Hände sichtbar halten, bitte|Mani in vista, per favore',
      'Documentos, por favor|Your documents, please|Documentos, por favor|Vos papiers, s\'il vous plaît|Ihre Papiere, bitte|Documenti, per favore',
      'Saia do veículo|Step out of the vehicle|Salga del vehículo|Sortez du véhicule|Steigen Sie aus dem Fahrzeug aus|Scenda dal veicolo',
      'Está detido|You are under arrest|Está detenido|Vous êtes en état d\'arrestation|Sie sind festgenommen|Lei è in arresto',
      'Tem o direito de permanecer em silêncio|You have the right to remain silent|Tiene derecho a permanecer en silencio|Vous avez le droit de garder le silence|Sie haben das Recht zu schweigen|Ha il diritto di rimanere in silenzio',
      'Quero falar com um advogado|I want to speak to a lawyer|Quiero hablar con un abogado|Je veux parler à un avocat|Ich möchte mit einem Anwalt sprechen|Voglio parlare con un avvocato',
      'Vou passar-lhe uma multa|I am giving you a fine|Le voy a poner una multa|Je vous mets une amende|Ich stelle Ihnen einen Strafzettel aus|Le faccio una multa',
      'Quero apresentar queixa|I want to file a report|Quiero presentar una denuncia|Je veux porter plainte|Ich möchte Anzeige erstatten|Voglio sporgere denuncia',
      'Roubaram-me o carro|My car was stolen|Me han robado el coche|On m\'a volé ma voiture|Mein Auto wurde gestohlen|Mi hanno rubato la macchina',
      'Fui assaltado|I was mugged|Me han atracado|Je me suis fait agresser|Ich wurde überfallen|Sono stato rapinato',
      'Não fiz nada|I didn\'t do anything|No he hecho nada|Je n\'ai rien fait|Ich habe nichts getan|Non ho fatto niente',
      'Onde fica a esquadra?|Where is the police station?|¿Dónde está la comisaría?|Où est le commissariat ?|Wo ist die Polizeiwache?|Dov\'è la stazione di polizia?',
      'Posso ir embora?|Can I go now?|¿Puedo irme?|Je peux partir ?|Kann ich gehen?|Posso andare?',
      'Vi um acidente|I saw an accident|He visto un accidente|J\'ai vu un accident|Ich habe einen Unfall gesehen|Ho visto un incidente',
      'Tenho licença de armas|I have a firearms licence|Tengo licencia de armas|J\'ai un permis de port d\'arme|Ich habe einen Waffenschein|Ho il porto d\'armi',
    ],
    'Hospital': [
      'Preciso de um médico|I need a doctor|Necesito un médico|J\'ai besoin d\'un médecin|Ich brauche einen Arzt|Ho bisogno di un medico',
      'Estou ferido|I am hurt|Estoy herido|Je suis blessé|Ich bin verletzt|Sono ferito',
      'Dói-me aqui|It hurts here|Me duele aquí|J\'ai mal ici|Es tut hier weh|Mi fa male qui',
      'Fui baleado|I have been shot|Me han disparado|On m\'a tiré dessus|Ich wurde angeschossen|Mi hanno sparato',
      'Não consigo respirar bem|I can\'t breathe properly|No puedo respirar bien|Je n\'arrive pas à bien respirer|Ich kann nicht richtig atmen|Non riesco a respirare bene',
      'Sou alérgico a...|I am allergic to...|Soy alérgico a...|Je suis allergique à...|Ich bin allergisch gegen...|Sono allergico a...',
      'Preciso de medicamentos|I need medication|Necesito medicamentos|J\'ai besoin de médicaments|Ich brauche Medikamente|Ho bisogno di medicine',
      'Onde fica o hospital?|Where is the hospital?|¿Dónde está el hospital?|Où est l\'hôpital ?|Wo ist das Krankenhaus?|Dov\'è l\'ospedale?',
      'Chamem uma ambulância|Call an ambulance|Llamen una ambulancia|Appelez une ambulance|Rufen Sie einen Krankenwagen|Chiamate un\'ambulanza',
      'Ele está inconsciente|He is unconscious|Está inconsciente|Il est inconscient|Er ist bewusstlos|È svenuto',
      'Quanto custa o tratamento?|How much does the treatment cost?|¿Cuánto cuesta el tratamiento?|Combien coûte le traitement ?|Was kostet die Behandlung?|Quanto costa la cura?',
      'Já estou melhor|I feel better now|Ya estoy mejor|Je me sens mieux|Mir geht es schon besser|Sto già meglio',
      'Tenho febre|I have a fever|Tengo fiebre|J\'ai de la fièvre|Ich habe Fieber|Ho la febbre',
      'Parti a perna|I broke my leg|Me he roto la pierna|Je me suis cassé la jambe|Ich habe mir das Bein gebrochen|Mi sono rotto la gamba',
      'Obrigado, doutor|Thank you, doctor|Gracias, doctor|Merci, docteur|Danke, Herr Doktor|Grazie, dottore',
    ],
    'Mecânico': [
      'O meu carro avariou|My car broke down|Mi coche se ha averiado|Ma voiture est en panne|Mein Auto hat eine Panne|La mia macchina si è guastata',
      'Podem rebocar o carro?|Can you tow the car?|¿Pueden remolcar el coche?|Pouvez-vous remorquer la voiture ?|Können Sie das Auto abschleppen?|Potete rimorchiare la macchina?',
      'Quanto custa a reparação?|How much is the repair?|¿Cuánto cuesta la reparación?|Combien coûte la réparation ?|Was kostet die Reparatur?|Quanto costa la riparazione?',
      'O motor faz um barulho estranho|The engine makes a strange noise|El motor hace un ruido raro|Le moteur fait un bruit bizarre|Der Motor macht ein komisches Geräusch|Il motore fa un rumore strano',
      'Preciso de pneus novos|I need new tyres|Necesito neumáticos nuevos|J\'ai besoin de pneus neufs|Ich brauche neue Reifen|Ho bisogno di gomme nuove',
      'Os travões não funcionam|The brakes don\'t work|Los frenos no funcionan|Les freins ne marchent pas|Die Bremsen funktionieren nicht|I freni non funzionano',
      'Fiquei sem combustível|I ran out of fuel|Me he quedado sin gasolina|Je suis en panne d\'essence|Mir ist der Sprit ausgegangen|Sono rimasto senza benzina',
      'Podem pintar o carro?|Can you paint the car?|¿Pueden pintar el coche?|Pouvez-vous peindre la voiture ?|Können Sie das Auto lackieren?|Potete verniciare la macchina?',
      'Quero melhorar o motor|I want to upgrade the engine|Quiero mejorar el motor|Je veux améliorer le moteur|Ich möchte den Motor tunen|Voglio potenziare il motore',
      'Quando fica pronto?|When will it be ready?|¿Cuándo estará listo?|Quand est-ce que ce sera prêt ?|Wann ist es fertig?|Quando sarà pronto?',
      'A bateria está descarregada|The battery is dead|La batería está descargada|La batterie est à plat|Die Batterie ist leer|La batteria è scarica',
      'Tenho um furo|I have a flat tyre|Tengo un pinchazo|J\'ai un pneu crevé|Ich habe einen Platten|Ho una gomma a terra',
      'Onde fica a oficina?|Where is the garage?|¿Dónde está el taller?|Où est le garage ?|Wo ist die Werkstatt?|Dov\'è l\'officina?',
      'Aceitam cartão?|Do you take card?|¿Aceptan tarjeta?|Vous acceptez la carte ?|Nehmen Sie Karte?|Accettate la carta?',
      'Obrigado pela ajuda|Thanks for the help|Gracias por la ayuda|Merci pour l\'aide|Danke für die Hilfe|Grazie per l\'aiuto',
    ],
    'Compras': [
      'Quanto custa isto?|How much is this?|¿Cuánto cuesta esto?|Combien ça coûte ?|Was kostet das?|Quanto costa questo?',
      'É muito caro|It\'s too expensive|Es muy caro|C\'est trop cher|Das ist zu teuer|È troppo caro',
      'Fazem desconto?|Do you give a discount?|¿Hacen descuento?|Vous faites une remise ?|Geben Sie Rabatt?|Fate uno sconto?',
      'Quero comprar isto|I want to buy this|Quiero comprar esto|Je veux acheter ça|Ich möchte das kaufen|Voglio comprare questo',
      'Posso pagar em dinheiro?|Can I pay in cash?|¿Puedo pagar en efectivo?|Je peux payer en espèces ?|Kann ich bar bezahlen?|Posso pagare in contanti?',
      'Têm isto noutra cor?|Do you have this in another colour?|¿Tienen esto en otro color?|Vous l\'avez dans une autre couleur ?|Haben Sie das in einer anderen Farbe?|Avete questo in un altro colore?',
      'Onde fica a loja de roupa?|Where is the clothes shop?|¿Dónde está la tienda de ropa?|Où est le magasin de vêtements ?|Wo ist das Bekleidungsgeschäft?|Dov\'è il negozio di vestiti?',
      'Estou só a ver|I\'m just looking|Solo estoy mirando|Je regarde seulement|Ich schaue nur|Sto solo guardando',
      'Pode dar-me um recibo?|Can I have a receipt?|¿Me da un recibo?|Je peux avoir un reçu ?|Kann ich eine Quittung haben?|Posso avere una ricevuta?',
      'Quero devolver isto|I want to return this|Quiero devolver esto|Je veux rendre ça|Ich möchte das zurückgeben|Voglio restituire questo',
      'A que horas fecham?|What time do you close?|¿A qué hora cierran?|À quelle heure fermez-vous ?|Wann schließen Sie?|A che ora chiudete?',
      'Vendo isto por...|I\'m selling this for...|Vendo esto por...|Je vends ça pour...|Ich verkaufe das für...|Vendo questo per...',
      'Dou-te metade do preço|I\'ll give you half the price|Te doy la mitad del precio|Je t\'en donne la moitié|Ich gebe dir die Hälfte|Ti do la metà del prezzo',
      'Está vendido|Sold|Vendido|Vendu|Verkauft|Venduto',
      'Preciso de um saco|I need a bag|Necesito una bolsa|J\'ai besoin d\'un sac|Ich brauche eine Tüte|Ho bisogno di una busta',
    ],
    'Direções': [
      'Onde fica...?|Where is...?|¿Dónde está...?|Où est... ?|Wo ist...?|Dov\'è...?',
      'Estou perdido|I am lost|Estoy perdido|Je suis perdu|Ich habe mich verlaufen|Mi sono perso',
      'Vira à esquerda|Turn left|Gira a la izquierda|Tourne à gauche|Links abbiegen|Gira a sinistra',
      'Vira à direita|Turn right|Gira a la derecha|Tourne à droite|Rechts abbiegen|Gira a destra',
      'Segue em frente|Go straight ahead|Sigue recto|Continue tout droit|Geradeaus weiter|Vai dritto',
      'É longe daqui?|Is it far from here?|¿Está lejos de aquí?|C\'est loin d\'ici ?|Ist es weit von hier?|È lontano da qui?',
      'Podes levar-me lá?|Can you take me there?|¿Puedes llevarme allí?|Peux-tu m\'y emmener ?|Kannst du mich dorthin bringen?|Puoi portarmi lì?',
      'Manda-me a localização|Send me the location|Mándame la ubicación|Envoie-moi la position|Schick mir den Standort|Mandami la posizione',
      'Encontramo-nos na praça|Let\'s meet at the square|Nos vemos en la plaza|On se retrouve sur la place|Treffen wir uns auf dem Platz|Ci vediamo in piazza',
      'Fica perto do hospital|It\'s near the hospital|Está cerca del hospital|C\'est près de l\'hôpital|Es ist in der Nähe des Krankenhauses|È vicino all\'ospedale',
      'Onde posso estacionar?|Where can I park?|¿Dónde puedo aparcar?|Où puis-je me garer ?|Wo kann ich parken?|Dove posso parcheggiare?',
      'Preciso de um táxi|I need a taxi|Necesito un taxi|J\'ai besoin d\'un taxi|Ich brauche ein Taxi|Ho bisogno di un taxi',
      'Quanto tempo demora?|How long does it take?|¿Cuánto tiempo se tarda?|Ça prend combien de temps ?|Wie lange dauert es?|Quanto tempo ci vuole?',
      'Estou a caminho|I\'m on my way|Voy de camino|J\'arrive|Ich bin unterwegs|Sto arrivando',
      'Espera aí por mim|Wait there for me|Espérame ahí|Attends-moi là|Warte dort auf mich|Aspettami lì',
    ],
    'Restaurante': [
      'Uma mesa para dois, por favor|A table for two, please|Una mesa para dos, por favor|Une table pour deux, s\'il vous plaît|Einen Tisch für zwei, bitte|Un tavolo per due, per favore',
      'A ementa, por favor|The menu, please|La carta, por favor|La carte, s\'il vous plaît|Die Speisekarte, bitte|Il menù, per favore',
      'O que recomenda?|What do you recommend?|¿Qué recomienda?|Que recommandez-vous ?|Was empfehlen Sie?|Cosa consiglia?',
      'Quero um hambúrguer|I want a burger|Quiero una hamburguesa|Je veux un hamburger|Ich möchte einen Burger|Voglio un hamburger',
      'Sem cebola, por favor|No onion, please|Sin cebolla, por favor|Sans oignon, s\'il vous plaît|Ohne Zwiebeln, bitte|Senza cipolla, per favore',
      'Uma água, por favor|A water, please|Un agua, por favor|Une eau, s\'il vous plaît|Ein Wasser, bitte|Un\'acqua, per favore',
      'A conta, por favor|The bill, please|La cuenta, por favor|L\'addition, s\'il vous plaît|Die Rechnung, bitte|Il conto, per favore',
      'Estava delicioso|It was delicious|Estaba delicioso|C\'était délicieux|Es war köstlich|Era delizioso',
      'Sou vegetariano|I am vegetarian|Soy vegetariano|Je suis végétarien|Ich bin Vegetarier|Sono vegetariano',
      'Para levar, por favor|To take away, please|Para llevar, por favor|À emporter, s\'il vous plaît|Zum Mitnehmen, bitte|Da portare via, per favore',
      'Fica com o troco|Keep the change|Quédese con el cambio|Gardez la monnaie|Stimmt so|Tenga il resto',
      'Tem mesa livre?|Do you have a free table?|¿Tiene mesa libre?|Avez-vous une table libre ?|Haben Sie einen freien Tisch?|Avete un tavolo libero?',
      'Mais um café, por favor|Another coffee, please|Otro café, por favor|Un autre café, s\'il vous plaît|Noch einen Kaffee, bitte|Un altro caffè, per favore',
      'Quanto é tudo?|How much is everything?|¿Cuánto es todo?|Ça fait combien en tout ?|Was macht das zusammen?|Quant\'è in tutto?',
      'Bom apetite|Enjoy your meal|Buen provecho|Bon appétit|Guten Appetit|Buon appetito',
    ],
    'Emergência': [
      'Socorro!|Help!|¡Socorro!|Au secours !|Hilfe!|Aiuto!',
      'Chamem a polícia|Call the police|Llamen a la policía|Appelez la police|Rufen Sie die Polizei|Chiamate la polizia',
      'Há um incêndio|There is a fire|Hay un incendio|Il y a un incendie|Es brennt|C\'è un incendio',
      'Há uma pessoa ferida|Someone is hurt|Hay una persona herida|Il y a un blessé|Jemand ist verletzt|C\'è una persona ferita',
      'Estou em perigo|I am in danger|Estoy en peligro|Je suis en danger|Ich bin in Gefahr|Sono in pericolo',
      'Larga a arma|Drop the weapon|Suelta el arma|Lâche l\'arme|Waffe fallen lassen|Lascia l\'arma',
      'Afastem-se|Stand back|Apártense|Reculez|Zurücktreten|State indietro',
      'Preciso de ajuda, depressa|I need help, quickly|Necesito ayuda, rápido|J\'ai besoin d\'aide, vite|Ich brauche schnell Hilfe|Ho bisogno di aiuto, presto',
      'Onde é a saída?|Where is the exit?|¿Dónde está la salida?|Où est la sortie ?|Wo ist der Ausgang?|Dov\'è l\'uscita?',
      'Fiquem calmos|Stay calm|Mantengan la calma|Restez calmes|Bleiben Sie ruhig|State calmi',
      'Houve um acidente na estrada|There was an accident on the road|Ha habido un accidente en la carretera|Il y a eu un accident sur la route|Es gab einen Unfall auf der Straße|C\'è stato un incidente sulla strada',
      'Estou a ser seguido|I am being followed|Me están siguiendo|On me suit|Ich werde verfolgt|Mi stanno seguendo',
      'Perdi o meu telemóvel|I lost my phone|He perdido mi móvil|J\'ai perdu mon téléphone|Ich habe mein Handy verloren|Ho perso il telefono',
      'Não me sinto bem|I don\'t feel well|No me encuentro bien|Je ne me sens pas bien|Mir geht es nicht gut|Non mi sento bene',
      'Está tudo bem agora|Everything is fine now|Ya está todo bien|Tout va bien maintenant|Jetzt ist alles in Ordnung|Adesso va tutto bene',
    ],
  };
  const PB_CATS = Object.keys(PB);
  const PB_ICON = { 'Cumprimentos': 'smile', 'Polícia': 'shield', 'Hospital': 'heart', 'Mecânico': 'gear', 'Compras': 'cart', 'Direções': 'compass', 'Restaurante': 'cart', 'Emergência': 'flag' };
  /* frase i da categoria: { cat, row: [pt, en, ...] } ; texto num idioma (ou null se o frasário não o tiver) */
  const pbAll = (() => { const out = []; PB_CATS.forEach(cat => PB[cat].forEach((s, i) => out.push({ cat, i, row: s.split('|') }))); return out; })();
  const pbText = (p, lang) => { const k = PB_LANGS.indexOf(lang); return k < 0 ? null : (p.row[k] || null); };
  const norm = s => String(s || '').trim().toLowerCase().replace(/[.!?¿¡]+$/g, '').replace(/\s+/g, ' ');
  /* tradução offline: a frase existe tal e qual no frasário no idioma de origem (ou em qualquer idioma com 'auto') */
  function pbLookup(text, from, to) {
    const n = norm(text); if (!n) return null; const kTo = PB_LANGS.indexOf(to); if (kTo < 0) return null;
    for (const p of pbAll) {
      for (let k = 0; k < PB_LANGS.length; k++) { if (from !== 'auto' && PB_LANGS[k] !== from) continue; if (norm(p.row[k]) === n && p.row[kTo]) return { text: p.row[kTo], from: PB_LANGS[k] }; }
    }
    return null;
  }

  /* ---------- tradução pelo servidor (resposta imediata se em cache, senão push translate:result) ---------- */
  const pending = new Map(); let seq = 0;
  if (window.Bridge && Bridge.on) Bridge.on('translate:result', d => { if (!d) return; const p = pending.get(+d.id); if (!p) return; pending.delete(+d.id); clearTimeout(p.t); p.res(d.error ? { error: d.error } : { text: d.text, from: d.from }); });
  function translate(text, from, to) {
    const off = pbLookup(text, from, to); if (off) return Promise.resolve({ text: off.text, from: off.from, offline: true });
    if (from !== 'auto' && from === to) return Promise.resolve({ text, from });
    const id = ++seq;
    return new Promise(res => {
      const t = setTimeout(() => { pending.delete(id); res({ error: 'timeout' }); }, 25000);
      pending.set(id, { res, t });
      Bridge.rpcRaw('translate.text', { id, text, from, to }).then(r => {
        if (!pending.has(id)) return;
        if (r && r.ok && r.pending) return;   /* o resultado chega pelo push */
        pending.delete(id); clearTimeout(t);
        res(!r ? { error: 'rpc' } : r.error ? { error: r.error, max: r.max } : { text: r.text, from: r.from, cached: !!r.cached });
      }).catch(() => { pending.delete(id); clearTimeout(t); res({ error: 'rpc' }); });
    });
  }
  const ERR = { nokey: 'O servidor não tem chave de IA configurada. A tradução ao vivo não está disponível, mas o Frasário funciona.', disabled: 'O Tradutor está desativado neste servidor.', limit: 'Atingiste o limite diário de traduções.', busy: 'Já há uma tradução a decorrer. Espera um instante.', blocked: 'Este texto não pode ser traduzido.', lang: 'Idioma não suportado.', invalid: 'Introduz um texto para traduzir.', empty: 'Não houve resposta para este texto.' };
  const errText = e => T(ERR[e] || 'O servidor não respondeu. Tenta novamente.');

  /* ---------- copiar / enviar ---------- */
  async function copyText(s) {
    try { if (navigator.clipboard && navigator.clipboard.writeText) { await navigator.clipboard.writeText(s); UI.toast('Copiado'); return true; } } catch (e) {}
    try { const ta = document.createElement('textarea'); ta.value = s; ta.setAttribute('readonly', ''); ta.style.cssText = 'position:fixed;left:0;top:0;opacity:0;pointer-events:none'; document.body.appendChild(ta); ta.select(); const ok = document.execCommand && document.execCommand('copy'); ta.remove(); if (ok) { UI.toast('Copiado'); return true; } } catch (e) {}
    UI.toast('Não foi possível copiar. Usa Enviar por mensagem.'); return false;
  }
  async function sendMessage(s) {
    if (!window.Contacts || !Contacts.pick) { UI.toast('Contactos indisponíveis'); return false; }
    const c = await Contacts.pick(T('Enviar tradução a')); if (!c || !c.number) return false;
    const r = await Bridge.rpcRaw('messages.send', { to: c.number, type: 'text', content: String(s).slice(0, 2000), app: 'sms' });
    if (!r || r.error) { Sound.play('error'); UI.toast('Não foi possível enviar'); return false; }
    Sound.play('send'); UI.toast(TF('Enviado a %s', c.name || c.number)); return true;
  }

  /* ---------- favoritos e histórico (Store, por personagem) ---------- */
  const favs = () => Store.get('trl:fav', []) || [], hist = () => Store.get('trl:hist', []) || [];
  const sameEntry = (a, b) => a.src === b.src && a.dst === b.dst && a.to === b.to;
  const isFav = e => favs().some(x => sameEntry(x, e));
  function toggleFav(e) { const l = favs(); const i = l.findIndex(x => sameEntry(x, e)); if (i > -1) l.splice(i, 1); else l.unshift(Object.assign({ t: Date.now() }, e)); Store.set('trl:fav', l.slice(0, 100)); return i < 0; }
  function pushHist(e) { const l = hist().filter(x => !sameEntry(x, e)); l.unshift(Object.assign({ t: Date.now() }, e)); Store.set('trl:hist', l.slice(0, 60)); }

  App.define('translate', {
    name: 'Tradutor', category: 'Utilitários', core: false, statusBar: 'auto',
    description: 'Traduz texto e conversas entre os idiomas do telemóvel, com um frasário offline para o dia a dia.',
    open(win) {
      const g = UI.g, esc = UI.esc;
      win.classList.add('trl'); if (isA()) win.classList.add('trl-a');
      const S = { cfg: null, from: Store.get('trl:from', null), to: Store.get('trl:to', null), cur: null, busy: false };
      if (!S.from) S.from = phoneLang(); if (!S.to) S.to = S.from === 'en' ? 'pt' : 'en';
      const saveLangs = () => { Store.set('trl:from', S.from); Store.set('trl:to', S.to); };
      Bridge.rpc('translate.config').then(c => { S.cfg = c || {}; if (S.text) S.text.hint(); });
      async function pickLang(title, cur, allowAuto) {
        const opts = (allowAuto ? [{ value: 'auto', label: T('Detetar idioma') }] : []).concat(LANG_ORDER().map(c => ({ value: c, label: langName(c) })));
        const v = await UI.picker(title, opts, cur); return v === undefined ? null : v;
      }

      /* ================= TEXTO ================= */
      const textView = () => {
        const v = UI.view({ title: 'Tradutor', large: true });
        const root = UI.el(`<div class="trl-main">
          <div class="trl-langs"><div class="trl-lp trl-lfrom"><span></span>${g('chevD', 14)}</div><div class="trl-swap">${g('rotate', 20)}</div><div class="trl-lp trl-lto"><span></span>${g('chevD', 14)}</div></div>
          <div class="trl-card trl-src"><textarea class="trl-ta" maxlength="${MAX_CHARS}" spellcheck="false" rows="4"></textarea><div class="trl-srcbar"><span class="trl-count">0 / ${MAX_CHARS}</span><div class="trl-clear">${g('x', 14)}</div></div></div>
          <div class="btn-p trl-go">Traduzir</div>
          <div class="trl-card trl-out" hidden><div class="trl-outhead"><span class="trl-outlang"></span><em class="trl-outsrc"></em></div><div class="trl-res" data-noi18n></div>
            <div class="trl-acts"><div class="trl-act trl-copy">${g('copy', 20)}<span>Copiar</span></div><div class="trl-act trl-send">${g('send', 20)}<span>Enviar por mensagem</span></div><div class="trl-act trl-fav">${g('star', 20)}<span>Favorito</span></div></div></div>
          <div class="trl-status" hidden></div>
          <div class="trl-hint"></div></div>`);
        v.content.appendChild(root); const $ = s => root.querySelector(s);
        const ta = $('.trl-ta'); ta.placeholder = T('Introduz o texto');
        const paintLangs = () => { $('.trl-lfrom span').textContent = langName(S.from); $('.trl-lto span').textContent = langName(S.to); };
        $('.trl-lfrom').onclick = async () => { const c = await pickLang(T('Idioma de origem'), S.from, true); if (c) { S.from = c; if (S.to === c) S.to = c === 'en' ? 'pt' : 'en'; saveLangs(); paintLangs(); } };
        $('.trl-lto').onclick = async () => { const c = await pickLang(T('Traduzir para'), S.to, false); if (c) { S.to = c; if (S.from === c) S.from = 'auto'; saveLangs(); paintLangs(); } };
        $('.trl-swap').onclick = () => { Sound.play('click'); const f = S.from === 'auto' ? (S.cur && S.cur.from) || phoneLang() : S.from; S.from = S.to; S.to = f; saveLangs(); paintLangs();
          if (S.cur) { ta.value = S.cur.dst; count(); run(); } };
        const count = () => { $('.trl-count').textContent = ta.value.length + ' / ' + MAX_CHARS; root.classList.toggle('has-text', !!ta.value.trim()); };
        ta.oninput = count; ta.onkeydown = e => { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); run(); } };
        $('.trl-clear').onclick = () => { ta.value = ''; count(); S.cur = null; $('.trl-out').hidden = true; status(''); ta.focus(); };
        const status = (msg, kind) => { const st = $('.trl-status'); st.hidden = !msg; st.textContent = msg || ''; st.className = 'trl-status' + (kind ? ' ' + kind : ''); };
        const hint = () => { const c = S.cfg; const h = $('.trl-hint'); if (!c) { h.textContent = ''; return; }
          if (c.enabled === false) h.textContent = T('O Tradutor está desativado neste servidor. O Frasário continua disponível.');
          else if (!c.hasKey) h.textContent = T('Sem chave de IA no servidor: só o Frasário offline traduz. Pede ao servidor para configurar a chave da Vera Chat.');
          else h.textContent = TF('Traduções de hoje: %s de %s. Frases do Frasário não contam.', String(c.used || 0), String(c.perDay || 0)); };
        function show(res, src) {
          S.cur = { src, dst: res.text, from: res.from || (S.from === 'auto' ? null : S.from), to: S.to };
          $('.trl-out').hidden = false; $('.trl-res').textContent = res.text; $('.trl-outlang').textContent = langName(S.to);
          $('.trl-outsrc').textContent = res.offline ? T('Frasário offline') : (S.from === 'auto' && res.from ? TF('Detetado: %s', langName(res.from)) : (res.cached ? T('Da memória do servidor') : ''));
          $('.trl-fav').classList.toggle('on', isFav(S.cur)); pushHist(S.cur); if (S.saved) S.saved.paint();
        }
        async function run() {
          const text = ta.value.trim(); if (!text) { status(T('Introduz um texto para traduzir.'), 'warn'); return; }
          if (S.busy) return; S.busy = true; root.classList.add('busy'); status(T('A traduzir…')); $('.trl-go').classList.add('dis');
          const r = await translate(text, S.from, S.to);
          S.busy = false; root.classList.remove('busy'); $('.trl-go').classList.remove('dis');
          if (!r || r.error) { status(errText(r && r.error), 'err'); if (r && r.error === 'nokey') { $('.trl-out').hidden = true; } Sound.play('error'); return; }
          status(''); show(r, text); Sound.play('tap');
          if (S.cfg && !r.offline && !r.cached) { S.cfg.used = (S.cfg.used || 0) + 1; hint(); }
        }
        $('.trl-go').onclick = run;
        $('.trl-copy').onclick = () => S.cur && copyText(S.cur.dst);
        $('.trl-send').onclick = () => S.cur && sendMessage(S.cur.dst);
        $('.trl-fav').onclick = () => { if (!S.cur) return; const on = toggleFav(S.cur); $('.trl-fav').classList.toggle('on', on); Sound.play('click'); UI.toast(on ? 'Guardado nos favoritos' : 'Removido dos favoritos'); if (S.saved) S.saved.paint(); };
        paintLangs(); count(); hint();
        S.text = { hint, load: e => { S.from = e.from || 'auto'; S.to = e.to; saveLangs(); paintLangs(); ta.value = e.src; count(); show({ text: e.dst, from: e.from }, e.src); } };
        return v;
      };

      /* ================= CONVERSA ================= */
      const convView = () => {
        const v = UI.view({ title: 'Conversa', large: true, right: [{ icon: 'trash', onTap: async () => { if (!S.conv.length) return; if (await UI.confirm(T('Limpar conversa?'), T('As mensagens desta conversa desaparecem.'), T('Limpar'), true)) { S.conv = []; paint(); } } }] });
        S.conv = S.conv || []; S.cA = S.cA || (S.from === 'auto' ? phoneLang() : S.from); S.cB = S.cB || S.to;
        const root = UI.el(`<div class="trl-conv"><div class="trl-cv-msgs"></div><div class="trl-cv-none"></div>
          <div class="trl-cv-bar"><div class="trl-cv-side trl-cv-a"><b></b><span>Escrever</span></div><div class="trl-cv-sw">${g('rotate', 18)}</div><div class="trl-cv-side trl-cv-b"><b></b><span>Escrever</span></div></div></div>`);
        v.content.appendChild(root); const $ = s => root.querySelector(s);
        const msgs = $('.trl-cv-msgs'), none = $('.trl-cv-none');
        const paintBar = () => { $('.trl-cv-a b').textContent = langName(S.cA); $('.trl-cv-b b').textContent = langName(S.cB); };
        function paint() { msgs.innerHTML = ''; S.conv.forEach(m => msgs.appendChild(bubble(m))); none.innerHTML = ''; none.hidden = !!S.conv.length; if (!S.conv.length) none.appendChild(UI.empty('translate', 'Conversa a dois', 'Cada pessoa escreve na sua língua e a tradução aparece para a outra. Toca no nome de um idioma para o mudar.'));
          const c = v.content; requestAnimationFrame(() => { c.scrollTop = c.scrollHeight; }); }
        const bubble = m => { const el = UI.el(`<div class="trl-bub ${m.side}"><div class="trl-bub-src" data-noi18n></div><div class="trl-bub-dst" data-noi18n></div><div class="trl-bub-l"></div></div>`); el.querySelector('.trl-bub-src').textContent = m.src; el.querySelector('.trl-bub-dst').textContent = m.dst; el.querySelector('.trl-bub-l').textContent = langName(m.from) + ' › ' + langName(m.to);
          el.onclick = () => UI.actionSheet({ buttons: [{ label: T('Copiar tradução'), icon: 'clipboard', value: 'copy' }, { label: T('Enviar por mensagem'), icon: 'send', value: 'send' }] }).then(a => { if (a === 'copy') copyText(m.dst); if (a === 'send') sendMessage(m.dst); }); return el; };
        async function speak(side) {
          const from = side === 'a' ? S.cA : S.cB, to = side === 'a' ? S.cB : S.cA;
          const body = UI.el(`<div class="trl-cv-sheet"><div class="trl-card trl-src"><textarea class="trl-ta" maxlength="${MAX_CHARS}" rows="4" spellcheck="false"></textarea></div><div class="trl-cv-hint"></div></div>`);
          const ta = body.querySelector('.trl-ta'); ta.placeholder = TF('Escreve em %s', langName(from)); body.querySelector('.trl-cv-hint').textContent = TF('A tradução aparece em %s.', langName(to));
          const sh = UI.sheet({ title: langName(from), left: 'Cancelar', right: 'Traduzir', body, onDone: () => { const text = ta.value.trim(); if (!text) { UI.toast('Escreve alguma coisa'); return false; }
            const m = { side, src: text, dst: '…', from, to, pending: true }; S.conv.push(m); paint();
            translate(text, from, to).then(r => { if (!r || r.error) { S.conv = S.conv.filter(x => x !== m); paint(); UI.alert({ title: T('Não traduzido'), msg: errText(r && r.error) }); return; } m.dst = r.text; m.pending = false; paint(); Sound.play('tap'); }); } });
          setTimeout(() => { try { ta.focus(); } catch (e) {} }, 350); return sh;
        }
        $('.trl-cv-a').onclick = () => speak('a'); $('.trl-cv-b').onclick = () => speak('b');
        $('.trl-cv-a b').onclick = async e => { e.stopPropagation(); const c = await pickLang(T('Idioma deste lado'), S.cA, false); if (c) { S.cA = c; paintBar(); } };
        $('.trl-cv-b b').onclick = async e => { e.stopPropagation(); const c = await pickLang(T('Idioma deste lado'), S.cB, false); if (c) { S.cB = c; paintBar(); } };
        $('.trl-cv-sw').onclick = () => { Sound.play('click'); const a = S.cA; S.cA = S.cB; S.cB = a; paintBar(); };
        paintBar(); paint(); return v;
      };

      /* ================= FRASÁRIO ================= */
      const pbView = () => {
        const v = UI.view({ title: 'Frasário', large: true });
        const srcL = () => PB_LANGS.includes(S.from) ? S.from : 'pt', dstL = () => PB_LANGS.includes(S.to) ? S.to : (srcL() === 'en' ? 'pt' : 'en');
        let cat = 0, q = '';
        const root = UI.el('<div class="trl-pb"><div class="trl-pb-chips"></div><div class="trl-pb-list"></div><div class="trl-pb-none"></div><div class="trl-pb-foot">Frasário offline em Português, Inglês, Espanhol, Francês, Alemão e Italiano. Para os outros idiomas usa o separador Tradutor.</div></div>');
        const search = UI.search('Pesquisar frases', s => { q = s; paint(); }); v.content.appendChild(search); v.content.appendChild(root);
        const $ = s => root.querySelector(s);
        $('.trl-pb-chips').appendChild(UI.chips(PB_CATS.map(T), 0, i => { cat = i; paint(); }));
        const list = $('.trl-pb-list'), none = $('.trl-pb-none');
        const actions = p => UI.actionSheet({ title: pbText(p, dstL()) || pbText(p, 'en'), buttons: [{ label: T('Copiar'), icon: 'clipboard', value: 'copy' }, { label: T('Enviar por mensagem'), icon: 'send', value: 'send' }, { label: T('Abrir no Tradutor'), icon: 'translate', value: 'open' }, { label: T('Favorito'), icon: 'star', value: 'fav' }] }).then(a => {
          const e = { src: pbText(p, srcL()) || p.row[0], dst: pbText(p, dstL()) || p.row[1], from: srcL(), to: dstL() };
          if (a === 'copy') copyText(e.dst); else if (a === 'send') sendMessage(e.dst); else if (a === 'fav') { toggleFav(e); UI.toast('Guardado nos favoritos'); if (S.saved) S.saved.paint(); }
          else if (a === 'open') { tabs.go(0); setTimeout(() => S.text && S.text.load(e), 80); } });
        function paint() {
          const sL = srcL(), dL = dstL(); const items = q ? pbAll.filter(p => p.row.some(s => s.toLowerCase().includes(q))) : pbAll.filter(p => p.cat === PB_CATS[cat]);
          list.innerHTML = ''; items.forEach(p => { const el = UI.el(`<div class="trl-ph"><div class="trl-ph-ic">${g(PB_ICON[p.cat] || 'book', 18)}</div><div class="trl-ph-b"><b data-noi18n></b><span data-noi18n></span></div>${g('chevR', 16)}</div>`);
            el.querySelector('b').textContent = pbText(p, sL) || p.row[0]; el.querySelector('span').textContent = pbText(p, dL) || p.row[1]; el.onclick = () => actions(p); list.appendChild(el); });
          none.innerHTML = ''; none.hidden = !!items.length; if (!items.length) none.appendChild(UI.empty('search', 'Sem frases', 'Nenhuma frase com essas palavras.'));
          root.querySelector('.trl-pb-chips').hidden = !!q;
        }
        paint(); S.pb = { paint }; return v;
      };

      /* ================= GUARDADO ================= */
      const savedView = () => {
        const v = UI.view({ title: 'Guardado', large: true });
        let mode = 0;
        const root = UI.el('<div class="trl-sv"><div class="trl-sv-seg"></div><div class="trl-sv-list"></div><div class="trl-sv-none"></div><div class="trl-sv-foot"></div></div>'); v.content.appendChild(root);
        const $ = s => root.querySelector(s);
        $('.trl-sv-seg').appendChild(UI.seg(['Favoritos', 'Histórico'], 0, i => { mode = i; paint(); }));
        const list = $('.trl-sv-list'), none = $('.trl-sv-none'), foot = $('.trl-sv-foot');
        function paint() {
          const items = mode === 0 ? favs() : hist(); list.innerHTML = '';
          items.forEach(e => { const el = UI.el(`<div class="trl-ph trl-svi"><div class="trl-ph-b"><b data-noi18n></b><span data-noi18n></span><em></em></div><div class="trl-sv-star ${isFav(e) ? 'on' : ''}">${g('star', 18)}</div></div>`);
            el.querySelector('b').textContent = e.dst; el.querySelector('span').textContent = e.src; el.querySelector('em').textContent = langName(e.from || 'auto') + ' › ' + langName(e.to) + ' · ' + UI.rel(e.t || Date.now());
            el.querySelector('.trl-sv-star').onclick = ev => { ev.stopPropagation(); const on = toggleFav(e); Sound.play('click'); paint(); UI.toast(on ? 'Guardado nos favoritos' : 'Removido dos favoritos'); };
            el.onclick = () => UI.actionSheet({ title: e.dst, buttons: [{ label: T('Abrir no Tradutor'), icon: 'translate', value: 'open' }, { label: T('Copiar tradução'), icon: 'clipboard', value: 'copy' }, { label: T('Enviar por mensagem'), icon: 'send', value: 'send' }] }).then(a => { if (a === 'copy') copyText(e.dst); else if (a === 'send') sendMessage(e.dst); else if (a === 'open') { tabs.go(0); setTimeout(() => S.text && S.text.load(e), 80); } });
            list.appendChild(el); });
          none.innerHTML = ''; none.hidden = !!items.length;
          if (!items.length) none.appendChild(mode === 0 ? UI.empty('star', 'Sem favoritos', 'Toca na estrela de uma tradução para a guardares aqui.') : UI.empty('clock', 'Sem histórico', 'As traduções que fizeres ficam aqui.'));
          foot.innerHTML = ''; if (mode === 1 && items.length) { const b = UI.el(`<div class="btn-p btn-s trl-sv-clear">${esc(T('Limpar histórico'))}</div>`); b.onclick = async () => { if (await UI.confirm(T('Limpar histórico?'), '', T('Limpar'), true)) { Store.set('trl:hist', []); paint(); } }; foot.appendChild(b); }
        }
        paint(); S.saved = { paint }; return v;
      };

      const tabs = UI.tabbar(win, [{ icon: 'translate', label: 'Texto', view: textView }, { icon: 'chat', label: 'Conversa', view: convView }, { icon: 'book', label: 'Frasário', view: pbView }, { icon: 'star', label: 'Guardado', view: savedView }], 0);
    },
  });

  /* ================= fallback do browser (LocalDB): tradução fictícia ================= */
  if (window.LocalDB && LocalDB.register) (() => {
    let used = 3;
    const DICT = { en: { 'olá': 'hello', 'bom dia': 'good morning', 'boa noite': 'good night', 'obrigado': 'thank you', 'por favor': 'please', 'sim': 'yes', 'não': 'no', 'onde': 'where', 'está': 'is', 'estou': 'I am', 'preciso': 'I need', 'de': 'of', 'um': 'a', 'uma': 'a', 'o': 'the', 'a': 'the', 'carro': 'car', 'casa': 'house', 'polícia': 'police', 'hospital': 'hospital', 'dinheiro': 'money', 'amigo': 'friend', 'hoje': 'today', 'amanhã': 'tomorrow', 'agora': 'now', 'ajuda': 'help', 'quero': 'I want', 'comprar': 'buy', 'vender': 'sell', 'telemóvel': 'phone', 'cidade': 'city', 'muito': 'very', 'bem': 'well', 'mal': 'badly', 'e': 'and', 'com': 'with', 'para': 'to', 'em': 'in' },
      es: { 'olá': 'hola', 'bom dia': 'buenos días', 'obrigado': 'gracias', 'por favor': 'por favor', 'sim': 'sí', 'não': 'no', 'onde': 'dónde', 'carro': 'coche', 'casa': 'casa', 'polícia': 'policía', 'dinheiro': 'dinero', 'amigo': 'amigo', 'hoje': 'hoy', 'agora': 'ahora', 'ajuda': 'ayuda', 'quero': 'quiero', 'telemóvel': 'móvil', 'cidade': 'ciudad', 'muito': 'muy', 'bem': 'bien', 'e': 'y', 'com': 'con', 'para': 'para', 'em': 'en', 'preciso': 'necesito', 'de': 'de', 'um': 'un', 'uma': 'una', 'o': 'el', 'a': 'la', 'está': 'está', 'estou': 'estoy' } };
    const fake = (text, to) => { const d = DICT[to] || DICT.en; let s = text; Object.keys(d).sort((a, b) => b.length - a.length).forEach(k => { s = s.replace(new RegExp('(^|[^\\p{L}])' + k.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '(?=$|[^\\p{L}])', 'giu'), (m, p) => p + d[k]); }); return s.charAt(0).toUpperCase() + s.slice(1); };
    LocalDB.register('translate.config', () => ({ enabled: true, hasKey: true, perDay: 150, used, maxChars: 1000, langs: ['pt', 'en', 'es', 'fr', 'de', 'it', 'nl', 'tr', 'pl', 'sv', 'da', 'ru', 'ja', 'ko', 'zh-Hans', 'zh-Hant'] }));
    LocalDB.register('translate.text', d => { const text = String(d.text || '').trim(); if (!text || !(+d.id > 0)) return { error: 'invalid' }; if (text.length > 1000) return { error: 'invalid' };
      const to = String(d.to || 'en'), from = String(d.from || 'auto'); if (from !== 'auto' && from === to) return { ok: true, id: +d.id, text, from, cached: true };
      const off = pbLookup(text, from, to); if (off) return { ok: true, id: +d.id, text: off.text, from: off.from, cached: true };
      used++; return new Promise(res => setTimeout(() => res({ ok: true, id: +d.id, text: fake(text, to), from: from === 'auto' ? 'pt' : from, to }), 500)); });
  })();
})();

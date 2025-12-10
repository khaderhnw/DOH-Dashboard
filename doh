import React, { useMemo, useState } from "react";
import {
  Baby,
  HeartPulse,
  ShieldCheck,
  School,
  Building2,
  Globe2,
  HandHeart,
  Stethoscope,
  ClipboardCheck,
  FileText,
  Sparkles,
  UserRound,
  CalendarCheck,
  AlertTriangle,
  CheckCircle2,
  Activity,
  Users,
  Briefcase,
  Home,
  BookOpen,
  ChevronRight,
  Search,
  Bell,
  ClipboardList,
  MapPin,
} from "lucide-react";

// --- MOCK UI COMPONENTS (Replaces @/components/ui) ---
const Card = ({ className, children }) => (
  <div className={`rounded-2xl border bg-white text-slate-950 shadow-sm ${className}`}>{children}</div>
);
const CardHeader = ({ className, children }) => (
  <div className={`flex flex-col space-y-1.5 p-6 ${className}`}>{children}</div>
);
const CardTitle = ({ className, children }) => (
  <h3 className={`text-2xl font-semibold leading-none tracking-tight ${className}`}>{children}</h3>
);
const CardDescription = ({ className, children }) => (
  <p className={`text-sm text-slate-500 ${className}`}>{children}</p>
);
const CardContent = ({ className, children }) => (
  <div className={`p-6 pt-0 ${className}`}>{children}</div>
);

const Button = ({ className, variant = "default", size = "default", children, ...props }) => {
  const variants = {
    default: "bg-slate-900 text-slate-50 hover:bg-slate-900/90",
    outline: "border border-slate-200 bg-white hover:bg-slate-100 hover:text-slate-900",
    secondary: "bg-slate-100 text-slate-900 hover:bg-slate-100/80",
    ghost: "hover:bg-slate-100 hover:text-slate-900",
  };
  const sizes = {
    default: "h-10 px-4 py-2",
    sm: "h-9 rounded-md px-3",
    icon: "h-10 w-10",
  };
  return (
    <button
      className={`inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-white transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-950 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 ${variants[variant]} ${sizes[size]} ${className}`}
      {...props}
    >
      {children}
    </button>
  );
};

const Badge = ({ className, variant = "default", children }) => {
  const variants = {
    default: "border-transparent bg-slate-900 text-slate-50 shadow",
    secondary: "border-transparent bg-slate-100 text-slate-900",
    outline: "text-slate-950 border-slate-200",
  };
  return (
    <span
      className={`inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold ${variants[variant]} ${className}`}
    >
      {children}
    </span>
  );
};

const Input = ({ className, ...props }) => (
  <input
    className={`flex h-10 w-full rounded-md border border-slate-200 bg-white px-3 py-2 text-sm ring-offset-white placeholder:text-slate-500 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-950 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 ${className}`}
    {...props}
  />
);

const Progress = ({ value, className }) => (
  <div className={`relative h-4 w-full overflow-hidden rounded-full bg-slate-100 ${className}`}>
    <div
      className="h-full w-full flex-1 bg-slate-900 transition-all"
      style={{ transform: `translateX(-${100 - (value || 0)}%)` }}
    />
  </div>
);

// Simplified Tabs for prototype
const Tabs = ({ value, onValueChange, tabs, className }) => (
  <div className={`space-y-4 ${className}`}>
    <div className="inline-flex items-center rounded-full bg-slate-100 p-1 text-xs">
      {tabs.map((tab) => (
        <button
          key={tab.value}
          onClick={() => onValueChange(tab.value)}
          className={`flex items-center gap-1 rounded-full px-3 py-1 transition ${
            value === tab.value
              ? "bg-white text-slate-900 shadow-sm"
              : "text-slate-500 hover:text-slate-900"
          }`}
        >
          {tab.icon && <tab.icon className="h-3 w-3" />}
          <span>{tab.label}</span>
        </button>
      ))}
    </div>
  </div>
);

// Badge helpers
const JourneyStageBadge = ({ stage }) => {
  const config = {
    PreMarital: { label: "Pre-marital", color: "bg-blue-50 text-blue-700 border-blue-100" },
    Expecting: { label: "Expecting", color: "bg-purple-50 text-purple-700 border-purple-100" },
    Newborn: { label: "Newborn", color: "bg-emerald-50 text-emerald-700 border-emerald-100" },
    Toddler: { label: "Toddler", color: "bg-amber-50 text-amber-700 border-amber-100" },
    PreSchool: { label: "Pre-school", color: "bg-sky-50 text-sky-700 border-sky-100" },
    SchoolAge: { label: "School age", color: "bg-indigo-50 text-indigo-700 border-indigo-100" },
    Youth: { label: "Youth", color: "bg-pink-50 text-pink-700 border-pink-100" },
  };

  const conf = config[stage] || config.Newborn;
  return (
    <span
      className={`inline-flex items-center gap-1 rounded-full border px-2.5 py-0.5 text-[0.65rem] font-medium ${conf.color}`}
    >
      <Sparkles className="h-3 w-3" />
      {conf.label}
    </span>
  );
};

// --- MOCK DATA ---

const familyProfile = {
  headOfFamily: {
    name: "Fatima Al Mansoori",
    role: "Mother",
    emirateId: "784-XXXX-XXXXXXX-1",
    avatarColor: "bg-indigo-500",
  },
  partner: {
    name: "Omar Al Mansoori",
    role: "Father",
    emirateId: "784-XXXX-XXXXXXX-2",
    avatarColor: "bg-emerald-500",
  },
  dependents: [
    {
      id: "1",
      name: "Baby Aya",
      age: "Newborn (3 days)",
      journeyStage: "Newborn",
      avatarColor: "bg-pink-500",
      relationship: "Newborn daughter",
      documents: [
        { type: "Birth Notification", status: "completed", ref: "BN-2025-001234" },
        { type: "Birth Certificate", status: "in-progress" },
        { type: "Emirates ID", status: "not-started" },
      ],
      health: {
        pediatricianAssigned: true,
        nextAppointment: "First well-baby visit in 4 days",
        immunizations: {
          completed: ["BCG (Tuberculosis)", "Hepatitis B dose 1"],
          upcoming: ["2-month vaccines set"],
        },
        insurance: {
          coverage: true,
          plan: "Mother’s corporate plan",
          cardIssued: false,
        },
      },
      housing: {
        registeredAddress: "Khalifa City A, Abu Dhabi",
        suitableForNewborn: true,
        notes: "Building has elevator and nearby clinic",
      },
      identity: {
        nationality: "UAE",
        religion: "Islam",
        language: "Arabic / English household",
      },
      educationFuture: {
        nurseryPlanning: "Not yet started",
        savingsPlan: "Considering education savings in 1–2 years",
      },
      keyRisks: [
        {
          id: "risk1",
          label: "Delayed identity issuance",
          type: "Regulatory",
          severity: "high",
          status: "warning",
          description: "Birth certificate and Emirates ID not yet completed.",
          suggestion: "Prioritize identity documents in next few days.",
        },
        {
          id: "risk2",
          label: "Immunization schedule adherence",
          type: "Health",
          severity: "medium",
          status: "info",
          description: "Upcoming vaccines require timely follow-up.",
          suggestion: "Enable appointment reminders and notifications.",
        },
      ],
    },
  ],
};

const serviceClusters = [
  {
    id: "identity",
    label: "Identity & documentation",
    icon: FileText,
    color: "bg-emerald-50 text-emerald-800 border-emerald-100",
    focus: "Who you are",
  },
  {
    id: "health",
    label: "Health & wellbeing",
    icon: HeartPulse,
    color: "bg-rose-50 text-rose-800 border-rose-100",
    focus: "How you’re cared for",
  },
  {
    id: "safety",
    label: "Safety & protection",
    icon: ShieldCheck,
    color: "bg-slate-50 text-slate-800 border-slate-100",
    focus: "How you’re protected",
  },
  {
    id: "housing",
    label: "Home & environment",
    icon: Home,
    color: "bg-amber-50 text-amber-800 border-amber-100",
    focus: "Where you live and grow",
  },
  {
    id: "education",
    label: "Learning & development",
    icon: School,
    color: "bg-sky-50 text-sky-800 border-sky-100",
    focus: "How you learn",
  },
  {
    id: "income",
    label: "Income & stability",
    icon: Briefcase,
    color: "bg-indigo-50 text-indigo-800 border-indigo-100",
    focus: "How you’re supported",
  },
  {
    id: "community",
    label: "Community & belonging",
    icon: Users,
    color: "bg-purple-50 text-purple-800 border-purple-100",
    focus: "Who you’re connected to",
  },
];

const identityJourney = [
  {
    id: "pre-birth",
    title: "Pre-birth registration",
    stage: "Before birth",
    status: "completed",
    icon: ClipboardCheck,
    description: "Hospital and parents registered for digital birth services.",
    actions: [],
  },
  {
    id: "birth-notification",
    title: "Birth notification",
    stage: "Hospital",
    status: "completed",
    icon: Baby,
    description: "Hospital issued birth notification with all required details.",
    actions: [],
  },
  {
    id: "birth-certificate",
    title: "Birth certificate",
    stage: "0–30 days",
    status: "in-progress",
    icon: FileText,
    description: "Parents need to confirm details and pay fees to issue certificate.",
    actions: [
      { label: "Review pre-filled data", type: "primary" },
      { label: "Upload missing documents", type: "secondary" },
    ],
  },
  {
    id: "emirates-id",
    title: "Emirates ID issuance",
    stage: "0–90 days",
    status: "not-started",
    icon: UserRound,
    description: "Aya’s Emirates ID will be triggered after birth certificate completion.",
    actions: [{ label: "Preview Emirates ID application", type: "primary" }],
  },
];

const healthJourney = [
  {
    id: "newborn-screening",
    title: "Newborn screening & tests",
    status: "completed",
    icon: Activity,
    description: "Metabolic and hearing screening completed at hospital.",
  },
  {
    id: "first-checkup",
    title: "First pediatric check-up",
    status: "scheduled",
    icon: Stethoscope,
    description: "Appointment scheduled at local clinic in 4 days.",
  },
  {
    id: "immunizations",
    title: "Immunization schedule",
    status: "ongoing",
    icon: ShieldCheck,
    description: "BCG and first Hepatitis B dose completed; next visit at 2 months.",
  },
];

const touchpoints = [
  {
    id: "tamm-family-space",
    label: "TAMM Family Space",
    type: "digital",
    icon: Globe2,
    primary: true,
    description: "One place where parents see Aya’s full journey, status, and actions.",
  },
  {
    id: "hospital",
    label: "Maternity hospital",
    type: "physical",
    icon: Building2,
    description: "Birth notification, screenings, and discharge guidance.",
  },
  {
    id: "clinic",
    label: "Local pediatric clinic",
    type: "physical",
    icon: Stethoscope,
    description: "Ongoing well-baby checks and vaccinations.",
  },
];

const experienceSignals = [
  {
    id: "clarity",
    label: "Clarity of “what’s next”",
    status: "strong",
    icon: Sparkles,
    description: "Parents see next steps clearly in TAMM with milestones and due dates.",
  },
  {
    id: "confidence",
    label: "Confidence everything is covered",
    status: "medium",
    icon: ShieldCheck,
    description: "Most steps are digital, but some offline tasks still feel uncertain.",
  },
  {
    id: "support",
    label: "Support & reassurance",
    status: "growing",
    icon: HandHeart,
    description: "Proactive tips and messaging can reduce anxiety for first-time parents.",
  },
];

const outcomeScorecards = [
  {
    id: "identity-completion",
    label: "Identity journey completion",
    value: 55,
    target: 100,
    description: "Progress through end-to-end identity setup for Aya.",
  },
  {
    id: "health-readiness",
    label: "Health readiness for first 90 days",
    value: 70,
    target: 100,
    description: "Foundational health checks, pediatric care, and immunization adherence.",
  },
  {
    id: "family-confidence",
    label: "Family confidence index",
    value: 62,
    target: 100,
    description: "How confident parents feel that everything important is covered.",
  },
];

const personaModes = [
  {
    id: "citizen",
    label: "Citizen pathway",
    description: "Aya is a UAE national child born to Emirati parents.",
    icon: Globe2,
    highlights: [
      "Eligible for full Emirati benefits from birth.",
      "Automatic linkage to parents’ family book.",
      "Streamlined education and housing pathways.",
    ],
  },
  {
    id: "resident",
    label: "Resident pathway",
    description: "Alternate view if Aya were born to resident expatriate parents.",
    icon: Users,
    highlights: [
      "Different health coverage and sponsorship rules.",
      "Visa and residency pathway instead of family book.",
      "Education and benefits differ from citizen pathway.",
    ],
  },
];

const quickActions = [
  {
    id: "resume-identity",
    label: "Resume identity journey for Baby Aya",
    description: "Continue from where the parents left off in TAMM.",
    icon: ChevronRight,
    type: "primary",
  },
  {
    id: "view-timeline",
    label: "View Aya’s life journey timeline",
    description: "See past steps and upcoming milestones at a glance.",
    icon: CalendarCheck,
  },
  {
    id: "compare-pathways",
    label: "Compare citizen vs resident pathway",
    description: "Understand key differences in rights and services.",
    icon: ClipboardList,
  },
];

const mockNotifications = [
  {
    id: "notif1",
    type: "identity",
    label: "Identity",
    message: "Birth certificate draft ready for review.",
    timeAgo: "2 hours ago",
    severity: "high",
  },
  {
    id: "notif2",
    type: "health",
    label: "Health",
    message: "Confirm pediatrician appointment for Aya.",
    timeAgo: "Today",
    severity: "medium",
  },
  {
    id: "notif3",
    type: "education",
    label: "Future",
    message: "Save Aya’s profile to reuse for future public school registration.",
    timeAgo: "This week",
    severity: "low",
  },
];

const serviceTimeline = [
  {
    id: "step1",
    title: "Before birth: Expectations & setup",
    icon: HandHeart,
    items: [
      "Parents learn about TAMM Family Space for life events.",
      "Hospital preregisters details for digital birth services.",
    ],
  },
  {
    id: "step2",
    title: "At birth: Hospital experience",
    icon: Baby,
    items: [
      "Aya is born at maternity hospital in Abu Dhabi.",
      "Birth notification and screenings are completed.",
      "Parents receive friendly guidance to “continue online in TAMM”.",
    ],
  },
  {
    id: "step3",
    title: "First week: Identity & health foundations",
    icon: FileText,
    items: [
      "Birth certificate completed in TAMM with pre-filled data.",
      "Emirates ID application triggered automatically.",
      "Pediatrician appointment booked with digital reminders.",
    ],
  },
  {
    id: "step4",
    title: "First 90 days: Stability & reassurance",
    icon: ShieldCheck,
    items: [
      "Vaccination schedule viewable in TAMM with status.",
      "Notifications if any critical steps are at risk or delayed.",
      "Linkage to housing, benefits, and future education options.",
    ],
  },
];

// Simple helper for status chips
const StatusChip = ({ status }) => {
  const map = {
    completed: {
      label: "Completed",
      className: "bg-emerald-50 text-emerald-700 border-emerald-100",
      icon: CheckCircle2,
    },
    "in-progress": {
      label: "In progress",
      className: "bg-amber-50 text-amber-700 border-amber-100",
      icon: Activity,
    },
    "not-started": {
      label: "Not started",
      className: "bg-slate-50 text-slate-700 border-slate-100",
      icon: AlertTriangle,
    },
    scheduled: {
      label: "Scheduled",
      className: "bg-sky-50 text-sky-700 border-sky-100",
      icon: CalendarCheck,
    },
    ongoing: {
      label: "Ongoing",
      className: "bg-indigo-50 text-indigo-700 border-indigo-100",
      icon: Activity,
    },
  };

  const conf = map[status] || map["not-started"];
  const Icon = conf.icon;

  return (
    <span
      className={`inline-flex items-center gap-1 rounded-full border px-2 py-0.5 text-[0.65rem] font-medium ${conf.className}`}
    >
      <Icon className="h-3 w-3" />
      {conf.label}
    </span>
  );
};

// --- MAIN DASHBOARD COMPONENT ---
export default function TammLifeDashboardPrototype() {
  const [selectedChild] = useState(familyProfile.dependents[0]);
  const [activeJourneyTab, setActiveJourneyTab] = useState("overview");
  const [personaMode, setPersonaMode] = useState("citizen");

  const identityProgress = useMemo(() => {
    const total = identityJourney.length;
    const completed = identityJourney.filter((step) => step.status === "completed").length;
    const inProgress = identityJourney.filter((step) => step.status === "in-progress").length;

    return {
      completed,
      inProgress,
      total,
      percentage: Math.round(((completed + inProgress * 0.5) / total) * 100),
    };
  }, []);

  const healthProgress = useMemo(() => {
    const total = healthJourney.length;
    const completed = healthJourney.filter((step) => step.status === "completed").length;
    const scheduled = healthJourney.filter((step) => step.status === "scheduled").length;

    return {
      completed,
      scheduled,
      total,
      percentage: Math.round(((completed + scheduled * 0.5) / total) * 100),
    };
  }, []);

  const risksSummary = useMemo(() => {
    const risks = selectedChild.keyRisks || [];
    const high = risks.filter((r) => r.severity === "high").length;
    const medium = risks.filter((r) => r.severity === "medium").length;
    const low = risks.filter((r) => r.severity === "low").length;

    return {
      high,
      medium,
      low,
      total: risks.length,
    };
  }, [selectedChild]);

  const personaConfig = useMemo(
    () => personaModes.find((p) => p.id === personaMode) || personaModes[0],
    [personaMode]
  );

  return (
    <div className="min-h-screen bg-slate-50 px-4 py-6 text-slate-900">
      <div className="mx-auto flex max-w-7xl flex-col gap-5">
        {/* Header */}
        <header className="flex flex-col gap-4 border-b border-slate-200 pb-4 md:flex-row md:items-center md:justify-between">
          <div className="space-y-2">
            <div className="inline-flex items-center gap-2 rounded-full bg-slate-900 px-3 py-1 text-xs text-slate-50">
              <Sparkles className="h-3 w-3" />
              <span>Prototype concept · TAMM Family Space · December 2025</span>
            </div>
            <div className="flex flex-wrap items-center gap-3">
              <div>
                <h1 className="text-2xl font-semibold tracking-tight md:text-3xl">
                  Baby Aya’s Life Journey · End-to-end newborn experience
                </h1>
                <p className="mt-1 max-w-2xl text-sm text-slate-600">
                  A single, human view of Aya’s first life milestone – going from birth to fully set up in the UAE –
                  across identity, health, home, and future.
                </p>
              </div>
            </div>
          </div>

          <div className="flex flex-col gap-3 md:items-end">
            <div className="flex items-center gap-2 text-xs text-slate-500">
              <MapPin className="h-3 w-3" />
              <span>Abu Dhabi · UAE</span>
            </div>
            <div className="flex items-center gap-2">
              <Input placeholder="Search in Aya’s journey" className="w-48" />
              <Button variant="outline" size="icon">
                <Bell className="h-4 w-4" />
              </Button>
            </div>
          </div>
        </header>

        {/* Main layout */}
        <div className="grid gap-4 lg:grid-cols-[minmax(0,1.8fr)_minmax(0,1.2fr)]">
          {/* Left column: Family & Journey */}
          <div className="flex flex-col gap-4">
            {/* Family card */}
            <Card className="overflow-hidden">
              <CardHeader className="border-b border-slate-100 pb-4">
                <div className="flex flex-wrap items-center justify-between gap-3">
                  <div className="flex items-center gap-3">
                    <div className="flex h-11 w-11 items-center justify-center rounded-full bg-indigo-500 text-sm font-semibold text-white">
                      {familyProfile.headOfFamily.name
                        .split(" ")
                        .map((n) => n[0])
                        .join("")}
                    </div>
                    <div>
                      <p className="text-xs font-medium uppercase tracking-wide text-slate-500">Family</p>
                      <p className="text-sm font-semibold">
                        {familyProfile.headOfFamily.name} &amp; {familyProfile.partner.name}
                      </p>
                      <p className="text-xs text-slate-500">Emirati family · 1 newborn child (Aya)</p>
                    </div>
                  </div>
                  <div className="flex flex-wrap items-center gap-2">
                    <Badge variant="secondary" className="rounded-full">
                      <Users className="mr-1 h-3 w-3" />
                      3 household members
                    </Badge>
                    <Badge variant="outline" className="rounded-full">
                      <Home className="mr-1 h-3 w-3" />
                      Khalifa City A · Abu Dhabi
                    </Badge>
                  </div>
                </div>
              </CardHeader>

              <CardContent className="pt-4">
                <div className="grid gap-4 md:grid-cols-[minmax(0,2fr)_minmax(0,1.4fr)]">
                  {/* Aya and journey snapshot */}
                  <div className="space-y-3">
                    <div className="flex items-start justify-between gap-2">
                      <div className="flex items-center gap-3">
                        <div className="flex h-10 w-10 items-center justify-center rounded-full bg-pink-500 text-sm font-semibold text-white">
                          {selectedChild.name
                            .split(" ")
                            .map((n) => n[0])
                            .join("")}
                        </div>
                        <div>
                          <div className="flex flex-wrap items-center gap-2">
                            <p className="text-sm font-semibold">{selectedChild.name}</p>
                            <JourneyStageBadge stage={selectedChild.journeyStage} />
                          </div>
                          <p className="text-xs text-slate-500">
                            {selectedChild.age} · {selectedChild.relationship}
                          </p>
                        </div>
                      </div>

                      <div className="flex flex-col items-end gap-1 text-right">
                        <p className="text-[0.7rem] font-medium uppercase tracking-wide text-slate-500">
                          Simple outcome view
                        </p>
                        <p className="text-sm text-slate-700">
                          {identityProgress.percentage}% identity · {healthProgress.percentage}% health foundations
                        </p>
                      </div>
                    </div>

                    <div className="grid gap-3 md:grid-cols-2">
                      <div className="space-y-2 rounded-xl bg-slate-50 p-3">
                        <div className="flex items-center justify-between gap-2">
                          <div className="flex items-center gap-2">
                            <FileText className="h-4 w-4 text-emerald-600" />
                            <p className="text-xs font-semibold text-slate-800">Identity journey</p>
                          </div>
                          <StatusChip status="in-progress" />
                        </div>
                        <Progress value={identityProgress.percentage} />
                        <p className="mt-1 text-[0.7rem] text-slate-500">
                          {identityProgress.completed} completed · {identityProgress.inProgress} in progress ·{" "}
                          {identityProgress.total - identityProgress.completed - identityProgress.inProgress} not yet
                          started
                        </p>
                      </div>

                      <div className="space-y-2 rounded-xl bg-slate-50 p-3">
                        <div className="flex items-center justify-between gap-2">
                          <div className="flex items-center gap-2">
                            <HeartPulse className="h-4 w-4 text-rose-600" />
                            <p className="text-xs font-semibold text-slate-800">Health foundations</p>
                          </div>
                          <StatusChip status="ongoing" />
                        </div>
                        <Progress value={healthProgress.percentage} />
                        <p className="mt-1 text-[0.7rem] text-slate-500">
                          {healthProgress.completed} completed · {healthProgress.scheduled} scheduled touchpoints
                        </p>
                      </div>
                    </div>

                    <div className="grid gap-3 md:grid-cols-3">
                      <div className="rounded-xl border border-slate-100 bg-white p-3">
                        <p className="text-[0.7rem] font-medium uppercase tracking-wide text-slate-500">
                          Health coverage
                        </p>
                        <div className="mt-1 flex items-center justify-between gap-2">
                          <div className="flex items-center gap-2">
                            <ShieldCheck className="h-4 w-4 text-emerald-600" />
                            <p className="text-xs font-semibold text-slate-800">
                              {selectedChild.health.insurance.coverage ? "Covered" : "Not covered yet"}
                            </p>
                          </div>
                          <Badge variant="secondary" className="rounded-full">
                            {selectedChild.health.insurance.plan}
                          </Badge>
                        </div>
                        <p className="mt-1 text-[0.7rem] text-slate-500">
                          Digital card{" "}
                          {selectedChild.health.insurance.cardIssued ? "issued & viewable in TAMM." : "to be issued."}
                        </p>
                      </div>

                      <div className="rounded-xl border border-slate-100 bg-white p-3">
                        <p className="text-[0.7rem] font-medium uppercase tracking-wide text-slate-500">
                          Upcoming milestone
                        </p>
                        <div className="mt-1 flex items-center gap-2">
                          <CalendarCheck className="h-4 w-4 text-sky-600" />
                          <p className="text-xs font-semibold text-slate-800">
                            {selectedChild.health.nextAppointment}
                          </p>
                        </div>
                        <p className="mt-1 text-[0.7rem] text-slate-500">
                          Parents can reschedule or change clinic directly in TAMM.
                        </p>
                      </div>

                      <div className="rounded-xl border border-slate-100 bg-white p-3">
                        <p className="text-[0.7rem] font-medium uppercase tracking-wide text-slate-500">
                          Risk signals
                        </p>
                        <div className="mt-1 flex items-center gap-2">
                          <AlertTriangle className="h-4 w-4 text-amber-600" />
                          <p className="text-xs font-semibold text-slate-800">
                            {risksSummary.total === 0 ? "No current risks" : `${risksSummary.total} active signals`}
                          </p>
                        </div>
                        <p className="mt-1 text-[0.7rem] text-slate-500">
                          {risksSummary.high > 0
                            ? `${risksSummary.high} high · ${risksSummary.medium} medium · ${risksSummary.low} low priority items`
                            : "No critical issues – keep following gentle reminders."}
                        </p>
                      </div>
                    </div>
                  </div>

                  {/* Quick actions & notifications */}
                  <div className="space-y-3 rounded-xl bg-slate-900/95 p-3 text-slate-50">
                    <div className="flex items-center justify-between gap-2">
                      <div>
                        <p className="text-[0.7rem] font-medium uppercase tracking-wide text-slate-300">
                          For prototype conversation
                        </p>
                        <p className="text-sm font-semibold text-slate-50">How could TAMM guide Aya’s family?</p>
                      </div>
                      <Badge className="rounded-full bg-emerald-500 text-[0.65rem] text-white">
                        <Sparkles className="mr-1 h-3 w-3" />
                        Concept view
                      </Badge>
                    </div>

                    <div className="space-y-2">
                      {quickActions.map((action) => (
                        <button
                          key={action.id}
                          className={`flex w-full items-start justify-between gap-2 rounded-lg border border-slate-700/60 bg-slate-900/50 px-3 py-2 text-left text-xs transition hover:border-slate-500 hover:bg-slate-800/80 ${
                            action.type === "primary" ? "border-emerald-500/80 bg-emerald-500/10" : ""
                          }`}
                        >
                          <div className="flex items-start gap-2">
                            <div
                              className={`mt-[2px] flex h-6 w-6 items-center justify-center rounded-full border border-slate-600/60 bg-slate-900/60`}
                            >
                              <action.icon className="h-3 w-3 text-emerald-300" />
                            </div>
                            <div>
                              <p className="text-[0.7rem] font-semibold text-slate-50">{action.label}</p>
                              <p className="text-[0.65rem] text-slate-300">{action.description}</p>
                            </div>
                          </div>
                          <ChevronRight className="mt-1 h-3 w-3 text-slate-400" />
                        </button>
                      ))}
                    </div>

                    <div className="space-y-1 rounded-lg bg-slate-900/70 p-2">
                      <div className="flex items-center justify-between gap-2">
                        <div className="flex items-center gap-2">
                          <Bell className="h-3 w-3 text-amber-300" />
                          <p className="text-[0.7rem] font-semibold text-slate-50">Live signals (sample)</p>
                        </div>
                        <button className="text-[0.65rem] text-slate-300 underline underline-offset-2">
                          View all
                        </button>
                      </div>
                      <div className="space-y-1.5">
                        {mockNotifications.slice(0, 2).map((notif) => (
                          <div
                            key={notif.id}
                            className="flex items-start justify-between gap-2 rounded-md bg-slate-900/60 px-2 py-1.5"
                          >
                            <div className="flex items-start gap-2">
                              <span className="mt-[2px] inline-flex h-4 w-4 items-center justify-center rounded-full bg-amber-500/20 text-[0.55rem] text-amber-200">
                                {notif.label[0]}
                              </span>
                              <div>
                                <p className="text-[0.65rem] text-slate-100">{notif.message}</p>
                                <p className="text-[0.6rem] text-slate-400">{notif.timeAgo}</p>
                              </div>
                            </div>
                            <span className="mt-[2px] inline-flex rounded-full bg-slate-900/80 px-1.5 py-0.5 text-[0.55rem] text-slate-300">
                              {notif.label}
                            </span>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Journey & service system */}
            <Card>
              <CardHeader className="flex flex-col gap-4 border-b border-slate-100 pb-4 md:flex-row md:items-center md:justify-between">
                <div className="space-y-1">
                  <div className="flex flex-wrap items-center gap-2">
                    <p className="text-xs font-medium uppercase tracking-wide text-slate-500">
                      Aya’s first life milestone
                    </p>
                    <Badge variant="outline" className="rounded-full border-dashed">
                      <Sparkles className="mr-1 h-3 w-3" />
                      Birth → “Fully set up child” in UAE
                    </Badge>
                  </div>
                  <p className="text-sm text-slate-600">
                    One place where a designer, policymaker, or product owner can see Aya’s shared journey across
                    services and channels.
                  </p>
                </div>
                <Tabs
                  value={activeJourneyTab}
                  onValueChange={setActiveJourneyTab}
                  tabs={[
                    { value: "overview", label: "Overview", icon: Search },
                    { value: "identity", label: "Identity journey", icon: FileText },
                    { value: "health", label: "Health journey", icon: HeartPulse },
                    { value: "touchpoints", label: "Touchpoints", icon: MapPin },
                  ]}
                />
              </CardHeader>

              <CardContent className="pt-4">
                {activeJourneyTab === "overview" && (
                  <div className="grid gap-4 md:grid-cols-[minmax(0,1.4fr)_minmax(0,1fr)]">
                    {/* Service system */}
                    <div className="space-y-3 rounded-xl bg-slate-50 p-3">
                      <div className="flex items-center justify-between gap-2">
                        <div>
                          <p className="text-[0.7rem] font-medium uppercase tracking-wide text-slate-500">
                            Service system clusters
                          </p>
                          <p className="text-xs text-slate-600">
                            Where Aya’s life flow crosses policies, ministries, and data silos.
                          </p>
                        </div>
                        <Badge variant="secondary" className="rounded-full">
                          <Building2 className="mr-1 h-3 w-3" />
                          Whole-of-government view
                        </Badge>
                      </div>
                      <div className="grid gap-2 md:grid-cols-3">
                        {serviceClusters.map((cluster) => (
                          <div
                            key={cluster.id}
                            className="flex flex-col gap-2 rounded-lg border border-slate-100 bg-white p-2 shadow-[0_1px_2px_rgba(15,23,42,0.04)]"
                          >
                            <div className="flex items-center justify-between gap-2">
                              <div className="flex items-center gap-2">
                                <div
                                  className={`flex h-7 w-7 items-center justify-center rounded-full border text-[0.6rem] ${cluster.color}`}
                                >
                                  <cluster.icon className="h-3 w-3" />
                                </div>
                                <p className="text-[0.7rem] font-semibold">{cluster.label}</p>
                              </div>
                            </div>
                            <p className="text-[0.65rem] text-slate-500">{cluster.focus}</p>
                            <div className="flex items-center justify-between gap-2 text-[0.6rem] text-slate-400">
                              <span>Sample services + outcomes tagged here</span>
                              <span>+ “behind-the-scenes” flows</span>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>

                    {/* Outcome scorecards */}
                    <div className="space-y-3 rounded-xl bg-slate-900/95 p-3 text-slate-50">
                      <div className="flex items-center justify-between gap-2">
                        <div>
                          <p className="text-[0.7rem] font-medium uppercase tracking-wide text-slate-300">
                            Simple outcomes, not just services
                          </p>
                          <p className="text-xs text-slate-100">
                            What “good looks like” for Aya’s first milestone.
                          </p>
                        </div>
                        <Badge className="rounded-full bg-emerald-500 text-[0.65rem] text-white">
                          <CheckCircle2 className="mr-1 h-3 w-3" />
                          Life outcome lens
                        </Badge>
                      </div>
                      <div className="space-y-2">
                        {outcomeScorecards.map((card) => (
                          <div
                            key={card.id}
                            className="space-y-1 rounded-lg border border-slate-700/60 bg-slate-900/70 px-3 py-2"
                          >
                            <div className="flex items-center justify-between gap-2">
                              <p className="text-[0.7rem] font-semibold text-slate-50">{card.label}</p>
                              <span className="text-[0.7rem] text-emerald-300">
                                {card.value}%{" "}
                                <span className="text-[0.6rem] text-slate-300">towards {card.target}%</span>
                              </span>
                            </div>
                            <Progress value={card.value} className="h-2" />
                            <p className="text-[0.65rem] text-slate-300">{card.description}</p>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                )}

                {activeJourneyTab === "identity" && (
                  <div className="grid gap-4 md:grid-cols-[minmax(0,1.6fr)_minmax(0,1.1fr)]">
                    <div className="space-y-3 rounded-xl bg-slate-50 p-3">
                      <div className="flex items-center justify-between gap-2">
                        <div>
                          <p className="text-[0.7rem] font-medium uppercase tracking-wide text-slate-500">
                            Identity journey for Aya
                          </p>
                          <p className="text-xs text-slate-600">
                            From hospital event to a fully recognized child in the UAE system.
                          </p>
                        </div>
                        <Badge variant="secondary" className="rounded-full">
                          <FileText className="mr-1 h-3 w-3" />
                          Linked across entities
                        </Badge>
                      </div>
                      <div className="space-y-3">
                        {identityJourney.map((step, idx) => (
                          <div
                            key={step.id}
                            className="relative flex gap-3 rounded-lg border border-slate-100 bg-white p-3 shadow-[0_1px_2px_rgba(15,23,42,0.04)]"
                          >
                            {idx !== identityJourney.length - 1 && (
                              <div className="absolute left-[14px] top-8 h-[calc(100%-2rem)] w-px bg-slate-200" />
                            )}
                            <div className="relative mt-1 flex h-6 w-6 items-center justify-center rounded-full border border-slate-200 bg-slate-50">
                              <step.icon className="h-3 w-3 text-slate-700" />
                            </div>
                            <div className="flex-1 space-y-1">
                              <div className="flex flex-wrap items-center justify-between gap-2">
                                <div className="flex flex-wrap items-center gap-2">
                                  <p className="text-[0.8rem] font-semibold text-slate-900">{step.title}</p>
                                  <span className="rounded-full bg-slate-50 px-2 py-0.5 text-[0.6rem] text-slate-500">
                                    {step.stage}
                                  </span>
                                </div>
                                <StatusChip status={step.status} />
                              </div>
                              <p className="text-[0.7rem] text-slate-600">{step.description}</p>
                              {step.actions?.length > 0 && (
                                <div className="flex flex-wrap gap-2 pt-1">
                                  {step.actions.map((action) => (
                                    <Button
                                      key={action.label}
                                      variant={action.type === "primary" ? "default" : "outline"}
                                      size="sm"
                                      className="h-7 rounded-full px-2.5 text-[0.7rem]"
                                    >
                                      {action.label}
                                    </Button>
                                  ))}
                                </div>
                              )}
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>

                    <div className="space-y-3">
                      <div className="rounded-xl bg-emerald-50 p-3">
                        <div className="flex items-center justify-between gap-2">
                          <div className="flex items-center gap-2">
                            <ShieldCheck className="h-4 w-4 text-emerald-700" />
                            <p className="text-[0.75rem] font-semibold text-emerald-900">
                              Identity risk and protection
                            </p>
                          </div>
                          <Badge variant="outline" className="rounded-full border-emerald-200 text-[0.65rem]">
                            Regulation + experience
                          </Badge>
                        </div>
                        <p className="mt-1 text-[0.7rem] text-emerald-800">
                          The design should ensure Aya never “falls through the cracks” between hospital, TAMM, and
                          federal systems. This view helps spot where friction or delay creates risk.
                        </p>
                        <div className="mt-2 space-y-1.5 rounded-lg bg-white/80 p-2 text-[0.7rem] text-emerald-900">
                          <div className="flex items-center justify-between gap-2">
                            <span>Identity risk snapshot</span>
                            <span className="rounded-full bg-emerald-50 px-2 py-0.5 text-[0.6rem] text-emerald-700">
                              {risksSummary.high} high · {risksSummary.medium} medium
                            </span>
                          </div>
                          <p className="text-[0.65rem] text-emerald-800">
                            In the concept, TAMM would quietly orchestrate across entities and surface only the key
                            next best action to parents, while giving designers and policymakers this richer view.
                          </p>
                        </div>
                      </div>

                      <div className="rounded-xl bg-slate-900/95 p-3 text-slate-50">
                        <div className="flex items-center justify-between gap-2">
                          <p className="text-[0.75rem] font-semibold text-slate-50">
                            Design note for discussion
                          </p>
                          <Badge className="rounded-full bg-slate-800 text-[0.65rem] text-slate-100">
                            <BookOpen className="mr-1 h-3 w-3" />
                            Workshop talking point
                          </Badge>
                        </div>
                        <p className="mt-1 text-[0.7rem] text-slate-100">
                          Today, services are often designed one-by-one. This prototype asks:{" "}
                          <span className="font-semibold">
                            “What if we designed Aya’s whole first year as a single life journey, and only then mapped
                            services?”
                          </span>{" "}
                          It can be used to align ministries, IT teams, and front-line staff around the same lived
                          story.
                        </p>
                      </div>
                    </div>
                  </div>
                )}

                {activeJourneyTab === "health" && (
                  <div className="grid gap-4 md:grid-cols-[minmax(0,1.4fr)_minmax(0,1fr)]">
                    <div className="space-y-3 rounded-xl bg-rose-50 p-3">
                      <div className="flex items-center justify-between gap-2">
                        <div>
                          <p className="text-[0.7rem] font-medium uppercase tracking-wide text-rose-700">
                            Health journey for Aya
                          </p>
                          <p className="text-xs text-rose-900">
                            From newborn screenings to first vaccines and ongoing reassurance.
                          </p>
                        </div>
                        <Badge variant="outline" className="rounded-full border-rose-200 text-[0.65rem] text-rose-800">
                          <HeartPulse className="mr-1 h-3 w-3" />
                          Health system lens
                        </Badge>
                      </div>
                      <div className="space-y-2">
                        {healthJourney.map((step) => (
                          <div
                            key={step.id}
                            className="flex gap-3 rounded-lg border border-rose-100 bg-white/90 p-3 shadow-[0_1px_2px_rgba(190,18,60,0.06)]"
                          >
                            <div className="mt-1 flex h-7 w-7 items-center justify-center rounded-full bg-rose-100">
                              <step.icon className="h-4 w-4 text-rose-700" />
                            </div>
                            <div className="flex-1 space-y-1">
                              <div className="flex items-center justify-between gap-2">
                                <p className="text-[0.8rem] font-semibold text-rose-900">{step.title}</p>
                                <StatusChip status={step.status} />
                              </div>
                              <p className="text-[0.7rem] text-rose-800">{step.description}</p>
                            </div>
                          </div>
                        ))}
                      </div>
                      <div className="rounded-lg bg-white/90 p-2 text-[0.7rem] text-rose-900">
                        <p className="font-medium">Design opportunity</p>
                        <p className="text-[0.65rem] text-rose-800">
                          This health view could be the same for all children, with paths that adapt for premature
                          babies, complex conditions, or different insurance statuses – but still feel simple and warm
                          to parents.
                        </p>
                      </div>
                    </div>

                    <div className="space-y-3">
                      <div className="rounded-xl bg-slate-900/95 p-3 text-slate-50">
                        <div className="flex items-center justify-between gap-2">
                          <p className="text-[0.75rem] font-semibold text-slate-50">
                            Experience signals during Aya’s newborn phase
                          </p>
                          <Badge className="rounded-full bg-rose-500 text-[0.65rem] text-white">
                            <HandHeart className="mr-1 h-3 w-3" />
                            Emotional journey
                          </Badge>
                        </div>
                        <div className="mt-2 space-y-2">
                          {experienceSignals.map((signal) => (
                            <div
                              key={signal.id}
                              className="space-y-1 rounded-lg border border-slate-700/60 bg-slate-900/70 px-3 py-2"
                            >
                              <div className="flex items-center justify-between gap-2">
                                <div className="flex items-center gap-2">
                                  <signal.icon className="h-4 w-4 text-rose-300" />
                                  <p className="text-[0.7rem] font-semibold text-slate-50">{signal.label}</p>
                                </div>
                                <span className="rounded-full bg-slate-900/80 px-2 py-0.5 text-[0.6rem] text-slate-200">
                                  {signal.status}
                                </span>
                              </div>
                              <p className="text-[0.65rem] text-slate-200">{signal.description}</p>
                            </div>
                          ))}
                        </div>
                      </div>

                      <div className="rounded-xl bg-white p-3">
                        <p className="text-[0.7rem] font-medium uppercase tracking-wide text-slate-500">
                          Policy & product note
                        </p>
                        <p className="mt-1 text-[0.7rem] text-slate-700">
                          This single view can be used to pressure-test{" "}
                          <span className="font-semibold">
                            how health, identity, and social policies meet a real family
                          </span>{" "}
                          – not as separate rules, but as one life story. The same canvas could be used for residents,
                          people of determination, or foster care scenarios.
                        </p>
                      </div>
                    </div>
                  </div>
                )}

                {activeJourneyTab === "touchpoints" && (
                  <div className="grid gap-4 md:grid-cols-[minmax(0,1.4fr)_minmax(0,1fr)]">
                    <div className="space-y-3 rounded-xl bg-slate-50 p-3">
                      <div className="flex items-center justify-between gap-2">
                        <div>
                          <p className="text-[0.7rem] font-medium uppercase tracking-wide text-slate-500">
                            Human and digital touchpoints
                          </p>
                          <p className="text-xs text-slate-600">
                            Where Aya’s parents actually experience this journey – online and offline.
                          </p>
                        </div>
                        <Badge variant="secondary" className="rounded-full">
                          <Globe2 className="mr-1 h-3 w-3" />
                          Omnichannel view
                        </Badge>
                      </div>
                      <div className="space-y-2">
                        {touchpoints.map((tp) => (
                          <div
                            key={tp.id}
                            className="flex gap-3 rounded-lg border border-slate-100 bg-white p-3 shadow-[0_1px_2px_rgba(15,23,42,0.04)]"
                          >
                            <div
                              className={`mt-1 flex h-7 w-7 items-center justify-center rounded-full ${
                                tp.type === "digital" ? "bg-indigo-50" : "bg-emerald-50"
                              }`}
                            >
                              <tp.icon
                                className={`h-4 w-4 ${
                                  tp.type === "digital" ? "text-indigo-700" : "text-emerald-700"
                                }`}
                              />
                            </div>
                            <div className="flex-1 space-y-1">
                              <div className="flex items-center justify-between gap-2">
                                <div className="flex items-center gap-2">
                                  <p className="text-[0.8rem] font-semibold text-slate-900">{tp.label}</p>
                                  <span className="rounded-full bg-slate-50 px-2 py-0.5 text-[0.6rem] text-slate-500">
                                    {tp.type === "digital" ? "Digital" : "In person"}
                                  </span>
                                  {tp.primary && (
                                    <span className="rounded-full bg-indigo-50 px-2 py-0.5 text-[0.6rem] text-indigo-700">
                                      Primary orchestrator
                                    </span>
                                  )}
                                </div>
                              </div>
                              <p className="text-[0.7rem] text-slate-600">{tp.description}</p>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>

                    <div className="space-y-3">
                      <div className="rounded-xl bg-slate-900/95 p-3 text-slate-50">
                        <div className="flex items-center justify-between gap-2">
                          <p className="text-[0.75rem] font-semibold text-slate-50">
                            Life-story alignment across teams
                          </p>
                          <Badge className="rounded-full bg-slate-800 text-[0.65rem] text-slate-100">
                            <Users className="mr-1 h-3 w-3" />
                            Cross-team view
                          </Badge>
                        </div>
                        <p className="mt-1 text-[0.7rem] text-slate-100">
                          This screen could be used in workshops with front-line staff, policy teams, and digital
                          product owners to ask:{" "}
                          <span className="font-semibold">
                            “Where does Aya’s family feel most supported, and where do we unintentionally create
                            worry?”
                          </span>
                        </p>
                      </div>

                      <div className="rounded-xl bg-white p-3">
                        <p className="text-[0.7rem] font-medium uppercase tracking-wide text-slate-500">
                          Persona pathway toggle
                        </p>
                        <div className="mt-2 inline-flex items-center rounded-full bg-slate-100 p-1 text-[0.7rem]">
                          {personaModes.map((mode) => (
                            <button
                              key={mode.id}
                              onClick={() => setPersonaMode(mode.id)}
                              className={`flex items-center gap-1 rounded-full px-2.5 py-1 transition ${
                                personaMode === mode.id
                                  ? "bg-white text-slate-900 shadow-sm"
                                  : "text-slate-500 hover:text-slate-900"
                              }`}
                            >
                              <mode.icon className="h-3 w-3" />
                              <span>{mode.label}</span>
                            </button>
                          ))}
                        </div>
                        <div className="mt-2 space-y-1.5 rounded-lg bg-slate-50 p-2 text-[0.7rem] text-slate-700">
                          <p className="font-semibold">{personaConfig.label}</p>
                          <p>{personaConfig.description}</p>
                          <ul className="list-disc space-y-0.5 pl-4 text-[0.65rem]">
                            {personaConfig.highlights.map((item, idx) => (
                              <li key={idx}>{item}</li>
                            ))}
                          </ul>
                          <p className="mt-1 text-[0.65rem] text-slate-500">
                            In a real product, this would not be a “toggle” – but different families would naturally see
                            the path that matches their legal and social reality. This view is just for design
                            conversations.
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                )}
              </CardContent>
            </Card>
          </div>

          {/* Right column: Timeline & narrative */}
          <div className="flex flex-col gap-4">
            <Card className="overflow-hidden">
              <CardHeader className="border-b border-slate-100 pb-3">
                <div className="flex items-center justify-between gap-2">
                  <div>
                    <p className="text-[0.7rem] font-medium uppercase tracking-wide text-slate-500">
                      Life event timeline
                    </p>
                    <p className="text-sm text-slate-700">
                      Birth of Aya → first 90 days of identity, health, and stability.
                    </p>
                  </div>
                  <Badge variant="outline" className="rounded-full text-[0.65rem]">
                    <CalendarCheck className="mr-1 h-3 w-3" />
                    Story-ready view
                  </Badge>
                </div>
              </CardHeader>

              <CardContent className="pt-3">
                <div className="space-y-3">
                  {serviceTimeline.map((step, index) => (
                    <div key={step.id} className="flex gap-3">
                      <div className="flex flex-col items-center">
                        <div
                          className={`flex h-7 w-7 items-center justify-center rounded-full ${
                            index === 0
                              ? "bg-indigo-50 text-indigo-700"
                              : index === serviceTimeline.length - 1
                              ? "bg-emerald-50 text-emerald-700"
                              : "bg-slate-50 text-slate-700"
                          }`}
                        >
                          <step.icon className="h-4 w-4" />
                        </div>
                        {index !== serviceTimeline.length - 1 && (
                          <div className="h-full w-px flex-1 bg-slate-200" />
                        )}
                      </div>
                      <div className="flex-1 space-y-1 rounded-lg bg-slate-50 p-2">
                        <div className="flex items-center justify-between gap-2">
                          <p className="text-[0.8rem] font-semibold text-slate-900">{step.title}</p>
                          <span className="rounded-full bg-white px-2 py-0.5 text-[0.6rem] text-slate-500">
                            {index === 0 && "Before birth"}
                            {index === 1 && "Day 0–2"}
                            {index === 2 && "First week"}
                            {index === 3 && "First 90 days"}
                          </span>
                        </div>
                        <ul className="list-disc space-y-0.5 pl-4 text-[0.7rem] text-slate-700">
                          {step.items.map((item, idx) => (
                            <li key={idx}>{item}</li>
                          ))}
                        </ul>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="border-b border-slate-100 pb-3">
                <div className="flex items-center justify-between gap-2">
                  <div>
                    <p className="text-[0.7rem] font-medium uppercase tracking-wide text-slate-500">
                      Optional narrative prompt
                    </p>
                    <p className="text-sm text-slate-700">
                      How to “tell Aya’s story” for leadership or cross-ministry alignment.
                    </p>
                  </div>
                  <Badge variant="outline" className="rounded-full text-[0.65rem]">
                    <BookOpen className="mr-1 h-3 w-3" />
                    Script helper
                  </Badge>
                </div>
              </CardHeader>

              <CardContent className="space-y-2 pt-3 text-[0.7rem] text-slate-700">
                <p>
                  <span className="font-semibold">“This is Aya.”</span> She is a newborn Emirati child, just three days
                  old, born in Abu Dhabi. Her parents, Fatima and Omar, are focused on her health, sleep, and adjusting
                  to life with a new baby – not on understanding the machinery of government.
                </p>
                <p>
                  In this prototype, we show how{" "}
                  <span className="font-semibold">
                    TAMM Family Space could hold Aya’s whole journey in one place
                  </span>{" "}
                  – from identity documents to health visits, housing suitability, and future education – while still
                  respecting the complexity behind the scenes.
                </p>
                <p>
                  For leaders, this is not “just another portal” – it’s{" "}
                  <span className="font-semibold">a life-story canvas</span> that can be reused for other journeys too:
                  a child of determination, a foster care scenario, or a teenager transitioning to work.
                </p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="pb-3">
                <CardTitle className="text-sm">Notes for next iteration</CardTitle>
                <CardDescription className="text-[0.7rem]">
                  Things you might explore next with policy, data, and design teams.
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-1.5 text-[0.7rem] text-slate-700">
                <ul className="list-disc space-y-0.5 pl-4">
                  <li>How might this view connect to existing TAMM data and events with minimal integration risk?</li>
                  <li>Which parts of Aya’s journey should be proactive by default (e.g. triggered automatically)?</li>
                  <li>
                    How might we visualize “gaps” — for example, if a parent stops mid-way or if different agencies
                    have conflicting information?
                  </li>
                  <li>
                    How could front-line staff (hospital, clinics, call centre) use a version of this view to quickly
                    help parents?
                  </li>
                  <li>
                    What does a similar canvas look like for a resident family, a blended family, or a child living
                    across two homes?
                  </li>
                </ul>
              </CardContent>
            </Card>

            {/* Small footer */}
            <div className="rounded-2xl border bg-white p-4 text-xs text-slate-600">
              This prototype illustrates a customer-first view of the birth and expanded life-journey concept inside
              TAMM Family Space. It is designed to keep the experience simple for families, while giving Abu Dhabi
              Government a richer story to align policy, data, and digital services – including supporting policy
              differences between citizen and resident pathways.
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

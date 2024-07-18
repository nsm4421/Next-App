import Link from "next/link";
import SignUpForm from "./_form";

export default function SignUpPage() {
  return (
    <main className="px-5 flex flex-col h-full">
      <div className="mx-auto my-auto w-10/12">
        <h1 className="text-xl">Sign Up</h1>
        <p className="text-sm text-slate-700 mt-2">
          you can sign up with email and password
        </p>
        <section className="mx-3 my-5 p-3">
          <SignUpForm />
        </section>

        <hr className="mx-8 border-gray-300" />

        <div className="mx-3 my-5 p-3 flex justify-center">
          <Link href="/sign-in">
            <span className="hover:text-orange-500">Already have account?</span>
          </Link>
        </div>
      </div>
    </main>
  );
}
